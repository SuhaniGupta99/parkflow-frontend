import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CurrentLocationButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 18,
      bottom: 300,
      child: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.white,
        elevation: 6,
        onPressed: onPressed,
        child: const Icon(
          Icons.my_location,
          color: Colors.green,
        ),
      ),
    );
  }
}