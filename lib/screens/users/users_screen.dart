import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../config/app_constants.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../models/user_model.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/main_layout.dart';
import 'user_form_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController())..fetchUsers();
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: const AppAppBar(title: 'Users'),
      floatingActionButton: authController.isAdmin
          ? FloatingActionButton(
              onPressed: () => Get.to(() => MainLayout(child: const UserFormScreen()))?.then((_) => controller.fetchUsers()),
              child: const Icon(Icons.add),
            )
          : null,
      body: Obx(() {
        final visibleUsers = controller.users;
        if (controller.isLoading.value && controller.users.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (visibleUsers.isEmpty) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value.isNotEmpty
                        ? controller.errorMessage.value
                        : 'No users yet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: controller.errorMessage.value.isNotEmpty
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
                  ),
                  if (controller.errorMessage.value.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => controller.fetchUsers(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchUsers,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: visibleUsers.length,
            itemBuilder: (_, i) {
              final user = visibleUsers[i];
              return _UserCard(
                user: user,
                onTap: authController.isAdmin
                    ? () => Get.to(() => MainLayout(child: UserFormScreen(userId: user.id)))?.then((_) => controller.fetchUsers())
                    : null,
                onEdit: authController.isAdmin
                    ? () => Get.to(() => MainLayout(child: UserFormScreen(userId: user.id)))?.then((_) => controller.fetchUsers())
                    : null,
                onDelete: authController.isAdmin ? () => _showDeleteDialog(context, controller, user) : null,
              );
            },
          ),
        );
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, UserController controller, UserModel user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete User'),
        content: Text('Delete "${user.fullName}"?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final ok = await controller.deleteUser(user.id);
              if (ok) { controller.fetchUsers(); Get.snackbar('Success', 'User deleted'); }
              else Get.snackbar('Error', controller.errorMessage.value);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _UserCard({required this.user, this.onTap, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final dateStr = user.createdAt != null
        ? DateFormat('MMM d, y • HH:mm').format(user.createdAt!)
        : '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SelectableText(dateStr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700)),
                  Chip(
                    label: Text(user.role, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(color: Theme.of(context).colorScheme.outline),
                    backgroundColor: Colors.transparent,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    child: Text(
                      (user.firstName.isNotEmpty ? user.firstName[0] : user.email.isNotEmpty ? user.email[0] : '?').toUpperCase(),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SelectableText(
                      user.fullName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SelectableText(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                  ),
                ],
              ),
              if (user.email.isNotEmpty || (user.phone != null && user.phone!.isNotEmpty))
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: SelectableText(
                    user.phone != null && user.phone!.isNotEmpty ? '${user.email} • ${user.phone}' : user.email,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                  ),
                ),
              if (onEdit != null || onDelete != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onEdit != null) IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: onEdit),
                    if (onDelete != null) IconButton(icon: const Icon(Icons.delete_outline, size: 20), onPressed: onDelete),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
