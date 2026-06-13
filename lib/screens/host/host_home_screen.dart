import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_listing_screen.dart';
import 'my_listings_screen.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class HostHomeScreen extends StatelessWidget {
  const HostHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Host Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {

              await Provider.of<AuthProvider>(
                context,
                listen: false,
              ).logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const LoginScreen(),
                ),
                (route) => false,
              );
            },
          )
        ],
      ),
      body: Padding(
  padding: const EdgeInsets.all(20),
  child: Column(
    children: [

      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const CreateListingScreen(),
              ),
            );
          },
          child: const Text(
            "Create Listing",
          ),
        ),
      ),

      const SizedBox(height: 16),

      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const MyListingsScreen(),
              ),
            );
          },
          child: const Text(
            "My Listings",
          ),
        ),
      ),
    ],
  ),
),
    );
  }
}