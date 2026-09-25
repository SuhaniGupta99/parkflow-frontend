import 'package:flutter/material.dart';
import '../../../core/widgets/inputs/pf_filter_chip.dart';
class MapFilterBar extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onSelected;

  const MapFilterBar({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });


  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      left: 16,
      right: 16,
      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal,
        child: Row(
          children: [

            PFFilterChip(
  label: "Nearest",
  icon: Icons.near_me,
  selected: selectedFilter == "Nearest",
  onTap: () => onSelected("Nearest"),
),

            const SizedBox(width: 8),

           PFFilterChip(
  label: "Cheapest",
  icon: Icons.currency_rupee,
  selected: selectedFilter == "Cheapest",
  onTap: () => onSelected("Cheapest"),
),

            const SizedBox(width: 8),

            PFFilterChip(
  label: "Available",
  icon: Icons.local_parking,
  selected: selectedFilter == "Available",
  onTap: () => onSelected("Available"),
),
          ],
        ),
      ),
    );
  }
}