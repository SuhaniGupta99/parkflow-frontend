import 'package:flutter/material.dart';

import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final fullNameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  String selectedRole = "CUSTOMER";

  bool isLoading = false;

  Future<void> register() async {
    try {
      setState(() {
        isLoading = true;
      });

      await AuthService().register(
        fullName:
            fullNameController.text.trim(),
        email:
            emailController.text.trim(),
        phoneNumber:
            phoneController.text.trim(),
        role: selectedRole,
        password:
            passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Registration Successful",
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            "Registration Failed: $e",
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
        title:
            const Text("Create Account"),
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller:
                  fullNameController,
              decoration:
                  const InputDecoration(
                labelText: "Full Name",
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  phoneController,
              decoration:
                  const InputDecoration(
                labelText:
                    "Phone Number",
              ),
            ),

            const SizedBox(height: 16),

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
                labelText:
                    "Password",
              ),
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration:
                  const InputDecoration(
                labelText:
                    "Account Type",
              ),
              items: const [
                DropdownMenuItem(
                  value: "CUSTOMER",
                  child: Text(
                    "Customer",
                  ),
                ),
                DropdownMenuItem(
                  value: "HOST",
                  child: Text(
                    "Host",
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole =
                      value!;
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isLoading
                        ? null
                        : register,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Create Account",
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}