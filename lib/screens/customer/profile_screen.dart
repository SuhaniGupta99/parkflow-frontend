import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../customer/vehicle_list_screen.dart';
import '../../core/enums/vehicle_list_mode.dart';
import '../../providers/auth_provider.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  Map<String, dynamic>? user;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadProfile();
  }

  Future<void> loadProfile() async {
    try {

      final token =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      ).token!;

      final response =
          await AuthService()
              .getMe(token);

      setState(() {
        user =
            response.data;

        isLoading = false;
      });

    } catch (e) {

      debugPrint(
        e.toString(),
      );

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
        ),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : Padding(
              padding:
                  const EdgeInsets.all(
                20,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                children: [

                  const Center(
                    child: CircleAvatar(
                      radius: 45,
                      child: Icon(
                        Icons.person,
                        size: 50,
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Text(
                    user?["full_name"] ??
                        "",
                    style:
                        const TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    user?["email"] ??
                        "",
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "Role: ${user?["role"] ?? ""}",
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  const Divider(),
ListTile(
  leading: const Icon(
    Icons.directions_car,
  ),
  title: const Text(
    "My Vehicles",
  ),
  trailing: const Icon(
    Icons.chevron_right,
  ),
  onTap: () {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VehicleListScreen(
          mode: VehicleListMode.management,
        ),
      ),
    );

  },
),

const Divider(),
                  ListTile(
                    leading:
                        const Icon(
                      Icons.logout,
                    ),
                    title:
                        const Text(
                      "Logout",
                    ),
                    onTap: () async {

                      await Provider.of<
                          AuthProvider>(
                        context,
                        listen: false,
                      ).logout();

                      if (!context
                          .mounted) {
                        return;
                      }

                      Navigator
                          .pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const LoginScreen(),
                        ),
                        (route) =>
                            false,
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}