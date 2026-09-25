import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';

class PFPrimaryButton extends StatelessWidget {

  final String text;

  final VoidCallback onPressed;

  final bool loading;

  const PFPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(

      height: 50,

      width: double.infinity,

      child: ElevatedButton(

        onPressed:
            loading ? null : onPressed,

        style: ElevatedButton.styleFrom(

          backgroundColor:
              AppColors.primary,

          foregroundColor:
              Colors.white,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius:
                AppRadius.medium,
          ),
        ),

        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(text),
      ),
    );
  }
}