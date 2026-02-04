import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/app_constants.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';
import '../../widgets/app_app_bar.dart';

class UserFormScreen extends StatelessWidget {
  final String? userId;

  const UserFormScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final isEdit = userId != null;
    final user = isEdit ? controller.users.firstWhereOrNull((u) => u.id == userId) : null;

    final firstNameController = TextEditingController(text: user?.firstName ?? '');
    final lastNameController = TextEditingController(text: user?.lastName ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');
    final passwordController = TextEditingController();
    final selectedRole = (user?.role ?? AppConstants.roleAdmin).obs;

    return Scaffold(
      appBar: AppAppBar(title: isEdit ? 'Edit User' : 'New User'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(controller: firstNameController, decoration: const InputDecoration(labelText: 'First Name'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: lastNameController, decoration: const InputDecoration(labelText: 'Last Name'), validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email *'), keyboardType: TextInputType.emailAddress, readOnly: isEdit, validator: (v) => v == null || v.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(controller: phoneController, decoration: const InputDecoration(labelText: 'Phone *'), keyboardType: TextInputType.phone, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: isEdit ? 'Password (leave blank to keep current)' : 'Password *',
                prefixIcon: const Icon(Icons.lock_outlined),
              ),
              obscureText: true,
              validator: isEdit ? null : (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            Obx(() => DropdownButtonFormField<String>(
              value: selectedRole.value,
              decoration: const InputDecoration(labelText: 'Role'),
              items: const [
                DropdownMenuItem(value: AppConstants.roleAdmin, child: Text('Admin')),
                DropdownMenuItem(value: AppConstants.roleCoach, child: Text('Coach')),
              ],
              onChanged: (v) => selectedRole.value = v ?? AppConstants.roleAdmin,
            )),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (firstNameController.text.trim().isEmpty || lastNameController.text.trim().isEmpty || emailController.text.trim().isEmpty || phoneController.text.trim().isEmpty) {
                  Get.snackbar('Error', 'First name, last name, email and phone are required');
                  return;
                }
                if (!isEdit && passwordController.text.isEmpty) {
                  Get.snackbar('Error', 'Password required');
                  return;
                }
                if (isEdit) {
                  final data = {
                    'firstName': firstNameController.text.trim(),
                    'lastName': lastNameController.text.trim(),
                    'phone': phoneController.text.trim(),
                    'role': selectedRole.value,
                  };
                  if (passwordController.text.isNotEmpty) data['password'] = passwordController.text;
                  final ok = await controller.updateUser(userId!, data);
                  if (ok) { Get.snackbar('Success', 'User updated'); Get.back(); }
                  else Get.snackbar('Error', controller.errorMessage.value);
                } else {
                  final data = {
                    'firstName': firstNameController.text.trim(),
                    'lastName': lastNameController.text.trim(),
                    'email': emailController.text.trim().toLowerCase(),
                    'phone': phoneController.text.trim(),
                    'password': passwordController.text,
                    'role': selectedRole.value,
                  };
                  final ok = await controller.createUser(data);
                  if (ok) { Get.snackbar('Success', 'User created'); Get.back(); }
                  else Get.snackbar('Error', controller.errorMessage.value);
                }
              },
              child: Text(isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
