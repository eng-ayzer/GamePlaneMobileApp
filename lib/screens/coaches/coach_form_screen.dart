import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/coach_controller.dart';
import '../../controllers/team_controller.dart';
import '../../models/coach_model.dart';
import '../../widgets/app_app_bar.dart';

class CoachFormScreen extends StatefulWidget {
  final String? coachId;

  const CoachFormScreen({super.key, this.coachId});

  @override
  State<CoachFormScreen> createState() => _CoachFormScreenState();
}

class _CoachFormScreenState extends State<CoachFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController licenseController;
  late final TextEditingController experienceController;
  late final TextEditingController nationalityController;
  final selectedTeamId = ''.obs;

  @override
  void initState() {
    super.initState();
    final coach = widget.coachId != null
        ? Get.find<CoachController>().coaches.firstWhereOrNull((c) => c.coachId == widget.coachId)
        : null;
    firstNameController = TextEditingController(text: coach?.firstName ?? '');
    lastNameController = TextEditingController(text: coach?.lastName ?? '');
    emailController = TextEditingController(text: coach?.email ?? '');
    phoneController = TextEditingController(text: coach?.phone ?? '');
    passwordController = TextEditingController();
    licenseController = TextEditingController(text: coach?.licenseLevel ?? '');
    experienceController = TextEditingController(text: coach?.experienceYears?.toString() ?? '');
    nationalityController = TextEditingController(text: coach?.nationality ?? '');
    selectedTeamId.value = coach?.teamId ?? '';
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    licenseController.dispose();
    experienceController.dispose();
    nationalityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coachId = widget.coachId;
    final coachController = Get.find<CoachController>();
    final teamController = Get.isRegistered<TeamController>() ? Get.find<TeamController>() : Get.put(TeamController());
    if (teamController.teams.isEmpty) teamController.fetchTeams();

    final isEdit = coachId != null;

    return Scaffold(
      appBar: AppAppBar(title: isEdit ? 'Edit Coach' : 'New Coach'),
      body: Obx(() {
        if (teamController.teams.isEmpty && !teamController.isLoading.value && isEdit) {
          return const Center(child: Text('Create a team first'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(controller: firstNameController, decoration: const InputDecoration(labelText: 'First Name *'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Last Name'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email *'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone *'),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: isEdit ? 'Password (leave blank to keep current)' : 'Password *',
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                obscureText: true,
                validator: isEdit ? null : (v) => v == null || v.isEmpty ? 'Required for coach login' : null,
              ),
              const SizedBox(height: 8),
              Text(
                'Coach logs in with email above and this password.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (_) {
                  final teams = teamController.teams;
                  final valueInItems = selectedTeamId.value.isNotEmpty &&
                      teams.any((t) => t.teamId == selectedTeamId.value);
                  final dropdownValue = valueInItems ? selectedTeamId.value : null;
                  return DropdownButtonFormField<String>(
                    value: dropdownValue,
                    decoration: InputDecoration(
                      labelText: isEdit ? 'Team *' : 'Team (assign when creating team)',
                    ),
                    validator: isEdit ? (v) => (v == null || v.toString().isEmpty) ? 'Select a team' : null : null,
                    items: [
                      const DropdownMenuItem(value: '', child: Text('No team yet')),
                      ...teams.map((t) => DropdownMenuItem(value: t.teamId, child: Text(t.name))),
                    ],
                    onChanged: (v) => selectedTeamId.value = v ?? '',
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(controller: licenseController, decoration: const InputDecoration(labelText: 'License Level')),
              const SizedBox(height: 16),
              TextFormField(controller: experienceController, decoration: const InputDecoration(labelText: 'Experience (years)'), keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              TextFormField(controller: nationalityController, decoration: const InputDecoration(labelText: 'Nationality')),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (!(_formKey.currentState?.validate() ?? false)) return;
                  if (!isEdit && passwordController.text.isEmpty) {
                    Get.snackbar('Error', 'Password required for coach login');
                    return;
                  }
                  final data = {
                    'first_name': firstNameController.text.trim(),
                    'last_name': lastNameController.text.trim(),
                    'email': emailController.text.trim(),
                    'phone': phoneController.text.trim(),
                    if (selectedTeamId.value.isNotEmpty) 'team_id': selectedTeamId.value,
                    if (licenseController.text.isNotEmpty) 'license_level': licenseController.text.trim(),
                    if (experienceController.text.isNotEmpty) 'experience_years': int.tryParse(experienceController.text) ?? 0,
                    if (nationalityController.text.isNotEmpty) 'nationality': nationalityController.text.trim(),
                    if (passwordController.text.isNotEmpty) 'password': passwordController.text,
                  };
                  final ok = isEdit ? await coachController.updateCoach(coachId!, data) : await coachController.createCoach(data);
                  if (ok) {
                    Get.snackbar('Success', 'Coach saved. Coach can log in with email and password.');
                    Get.back();
                  } else {
                    Get.snackbar('Error', coachController.errorMessage.value);
                  }
                },
                child: Text(isEdit ? 'Update' : 'Create'),
              ),
            ],
          ),
        ),
        );
      }),
    );
  }
}
