import 'package:flutter/material.dart';

import '../../../core/widgets/inputs/pf_search_bar.dart';

class MapSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const MapSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 16,
      right: 16,
      child: PFSearchBar(
        controller: controller,
        hint: "Search parking...",
        onChanged: onChanged,
      ),
    );
  }
}