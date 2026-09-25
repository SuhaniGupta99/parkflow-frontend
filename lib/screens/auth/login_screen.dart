import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../customer/customer_main_screen.dart';
import '../host/host_home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> login() async {
    try {
      setState(() {
        isLoading = true;
      });

      final authService = AuthService();

      final loginResponse =
          await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final token =
          loginResponse.data["access_token"];

      final authProvider =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      );

      await authProvider.saveToken(
        token,
      );

      final meResponse =
          await authService.getMe(token);

      final role =
          meResponse.data["role"];
      final fullName =
          meResponse.data["full_name"];

      await authProvider.saveRole(
        role,
      );
      await authProvider.saveFullName(
        fullName,
        );

      if (!mounted) return;

      if (role == "HOST") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const HostHomeScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const CustomerMainScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Login Failed: $e",
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ParkFlow"),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            TextField(
              controller:
                  emailController,
              decoration:
                  const InputDecoration(
                labelText: "Email",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText: "Password",
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed:
                  isLoading ? null : login,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Login",
                    ),
            ),

            const SizedBox(height: 16),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const RegisterScreen(),
                  ),
                );
              },
              child: const Text(
                "Create Account",
              ),
            )
          ],
        ),
      ),
    );
  }
}