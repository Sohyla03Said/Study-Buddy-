import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double height;
  final double width;
  final bool isSecondary;
  final bool enabled;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.height = 50,
    this.width = double.infinity,
    this.isSecondary = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.white : AppColors.primary,
          foregroundColor: isSecondary ? AppColors.primary : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSecondary
                ? BorderSide(color: AppColors.primary, width: 1)
                : BorderSide.none,
          ),
          elevation: isSecondary ? 0 : 2,
          shadowColor: isSecondary
              ? Colors.transparent
              : AppColors.primary.withOpacity(0.3),
        ),
        child: Text(
          text,
          style: AppTextStyles.body1.copyWith(
            fontWeight: FontWeight.w600,
            color: isSecondary ? AppColors.primary : Colors.white,
          ),
        ),
      ),
    );
  }
}
