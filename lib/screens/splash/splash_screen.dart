import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(const Duration(milliseconds: 1500)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final authController = Get.find<AuthController>();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (authController.isLoggedIn) {
                  Get.offAllNamed(AppRoutes.dashboard);
                } else {
                  Get.offAllNamed(AppRoutes.public);
                }
              });
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sports_soccer, size: 80, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 24),
                Text(
                  'GamePlane',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sports Management Platform',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 48),
                const CircularProgressIndicator(),
              ],
            );
          },
        ),
      ),
    );
  }
}
