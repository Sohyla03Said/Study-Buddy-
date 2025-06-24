import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/colors.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageButton(
                context,
                'English',
                'EN',
                !languageProvider.isArabic,
                    () => languageProvider.changeLanguage(const Locale('en')),
              ),
              _buildLanguageButton(
                context,
                'العربية',
                'AR',
                languageProvider.isArabic,
                    () => languageProvider.changeLanguage(const Locale('ar')),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton(
      BuildContext context,
      String fullName,
      String shortName,
      bool isSelected,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          shortName,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}