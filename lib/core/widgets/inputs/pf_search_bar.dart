import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';

class PFSearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  
  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final VoidCallback? onFilterTap;

  const PFSearchBar({
    super.key,
    required this.hint,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadius.large,
        onTap: onTap == null ? null : onTap,
        child: Container(
          height: 58,

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.large,
            boxShadow: AppShadows.card,
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),

          child: Row(
            children: [

              const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),

              const SizedBox(width: 12),

              Expanded(
  child: TextField(
    controller: controller,
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.hint,
      ),
      border: InputBorder.none,
    ),
  ),
),

              IconButton(
                onPressed: onFilterTap,
                icon: const Icon(
                  Icons.tune,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}