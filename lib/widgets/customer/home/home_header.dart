import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';

import '../../../core/widgets/inputs/pf_search_bar.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    }

    if (hour < 17) {
      return "Good Afternoon";
    }

    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        Provider.of<AuthProvider>(context);

    final firstName =
        auth.fullName?.split(" ").first ??
            "User";

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          "${getGreeting()},",
          style:
              AppTextStyles.body.copyWith(
            color:
                AppColors.textSecondary,
          ),
        ),

        const SizedBox(
          height: AppSpacing.xs,
        ),

        Text(
          "$firstName 👋",
          style:
              AppTextStyles.heading1,
        ),

        const SizedBox(
          height: AppSpacing.sm,
        ),

        Text(
          "Find the perfect parking space near you",
          style:
              AppTextStyles.body,
        ),

        const SizedBox(
          height: AppSpacing.lg,
        ),

        const PFSearchBar(
          hint:
              "Search destination or parking...",
        ),
      ],
    );
  }
}