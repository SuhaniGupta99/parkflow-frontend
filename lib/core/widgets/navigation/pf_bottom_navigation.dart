import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PFBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PFBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          0,
          20,
          20,
        ),
        child: Container(
          height: 72,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(22),

            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),

          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,

            children: [

              buildItem(
                Icons.home_rounded,
                "Home",
                0,
              ),

              buildItem(
                Icons.map_rounded,
                "Map",
                1,
              ),

              buildItem(
                Icons.receipt_long_rounded,
                "Bookings",
                2,
              ),

              buildItem(
                Icons.person_rounded,
                "Profile",
                3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(
    IconData icon,
    String title,
    int index,
  ) {
    final selected =
        currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 250,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
                  .withOpacity(0.12)
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              color: selected
                  ? AppColors.primary
                  : Colors.grey,
            ),

            const SizedBox(
              height: 4,
            ),

            Text(
              title,

              style: TextStyle(
                fontSize: 11,

                fontWeight:
                    FontWeight.w600,

                color: selected
                    ? AppColors.primary
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}