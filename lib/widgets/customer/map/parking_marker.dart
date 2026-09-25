import 'package:flutter/material.dart';

class ParkingMarker extends StatelessWidget {
  final double price;
  final bool selected;

  const ParkingMarker({
    super.key,
    required this.price,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(
        milliseconds: 250,
      ),
      scale: selected ? 1.2 : 1,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.orange
                  : Colors.green,
              borderRadius:
                  BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black26,
                ),
              ],
            ),
            child: Text(
              "₹${price.toInt()}",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: selected
                  ? Colors.orange
                  : Colors.green,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}