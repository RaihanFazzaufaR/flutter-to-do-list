import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'dashboard_page.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (authProvider.isLoggedIn) {
      // Setup TaskProvider for this user
      context.read<TaskProvider>().setUserId(authProvider.userId!);
      return DashboardPage(
        username: authProvider.username!, 
        userId: authProvider.userId!
      );
    }

    return const LoginPage();
  }
}
