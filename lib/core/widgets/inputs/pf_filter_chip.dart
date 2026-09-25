import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PFFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const PFFilterChip({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 220,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white,

          borderRadius:
              BorderRadius.circular(24),

          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              size: 18,
              color: selected
                  ? Colors.white
                  : Colors.grey.shade700,
            ),

            const SizedBox(width: 6),

            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}