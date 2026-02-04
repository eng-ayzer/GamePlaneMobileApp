import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../widgets/app_app_bar.dart';

/// Separate page for Admin to update a user's password
class UpdateUserPasswordScreen extends StatefulWidget {
  final String userId;

  const UpdateUserPasswordScreen({super.key, required this.userId});

  @override
  State<UpdateUserPasswordScreen> createState() => _UpdateUserPasswordScreenState();
}

class _UpdateUserPasswordScreenState extends State<UpdateUserPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final user = controller.users.firstWhereOrNull((u) => u.id == widget.userId);

    return Scaffold(
      appBar: AppAppBar(title: 'Update User Password'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (user != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(user.fullName, style: Theme.of(context).textTheme.titleMedium),
                      Text(user.email, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              Text('New Password', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _newPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Enter new password',
                  hintText: 'Minimum 6 characters',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (v) => v == null || v.length < 6 ? 'At least 6 characters required' : null,
              ),
              const SizedBox(height: 16),
              Text('Confirm Password', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm new password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (v != _newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!(_formKey.currentState?.validate() ?? false)) return;
                        setState(() => _loading = true);
                        try {
                          final ok = await controller.updateUser(
                            widget.userId,
                            {'password': _newPasswordController.text},
                          );
                          if (ok) {
                            Get.snackbar('Success', 'Password updated');
                            Get.back();
                          } else {
                            Get.snackbar('Error', controller.errorMessage.value);
                          }
                        } finally {
                          setState(() => _loading = false);
                        }
                      },
                child: _loading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Update Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
