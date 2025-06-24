import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../models/user_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/language_selector.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selectedRole;

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.isArabic;

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Language Selector at top
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isArabic ? Icons.arrow_forward : Icons.arrow_back,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                      ),
                      const LanguageSelector(),
                    ],
                  ),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          isArabic ? 'اختر دورك' : 'Select Your Role',
                          style: AppTextStyles.heading1.copyWith(
                            fontSize: 36,
                            color: AppColors.highContrastText,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 60),

                        // Role Selection Cards
                        _buildRoleCard(
                          role: UserRole.teacher,
                          title: isArabic ? 'معلم' : 'Teacher',
                          subtitle: isArabic
                              ? 'قم بإنشاء وإدارة الدروس والطلاب'
                              : 'Create and manage lessons and students',
                          imagePath: 'assets/images/teacher.png',
                          isSelected: _selectedRole == UserRole.teacher,
                        ),

                        const SizedBox(height: 24),

                        _buildRoleCard(
                          role: UserRole.student,
                          title: isArabic ? 'طالب' : 'Student',
                          subtitle: isArabic
                              ? 'تعلم واكتشف دروس جديدة'
                              : 'Learn and discover new lessons',
                          imagePath: 'assets/images/student.png',
                          isSelected: _selectedRole == UserRole.student,
                        ),

                        const SizedBox(height: 40),

                        // Continue Button - Fixed implementation
                        GestureDetector(
                          onTap: _selectedRole != null ? _handleContinue : null,
                          child: Container(
                            height: 60,
                            width: 250,
                            decoration: BoxDecoration(
                              color: _selectedRole != null ? AppColors.primary : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                isArabic ? 'متابعة' : 'Continue',
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Test App Button - Fixed implementation
                        GestureDetector(
                          onTap: _selectedRole != null ? _handleTestApp : null,
                          child: AnimatedOpacity(
                            opacity: _selectedRole != null ? 1.0 : 0.3,
                            duration: const Duration(milliseconds: 300),
                            child: Container(
                              height: 60,
                              width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange, width: 2),
                                color: Colors.orange.withOpacity(0.1),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.bug_report,
                                    color: _selectedRole != null ? Colors.orange : Colors.grey,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    isArabic ? 'تجربة التطبيق' : 'Test App',
                                    style: AppTextStyles.body1.copyWith(
                                      color: _selectedRole != null ? Colors.orange : Colors.grey,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String subtitle,
    required String imagePath,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(isSelected ? 0.95 : 0.85),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.heading3.copyWith(
                color: isSelected ? AppColors.primary : AppColors.highContrastText,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.body1.copyWith(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    print('Continue button pressed. Selected role: $_selectedRole');
    if (_selectedRole != null) {
      print('Navigating to welcome page with role: $_selectedRole');
      Navigator.pushNamed(
        context,
        '/welcome-page',
        arguments: _selectedRole,
      ).catchError((error) {
        print('Navigation error: $error');
      });
    } else {
      print('No role selected, cannot continue');
    }
  }

  // Handle test app navigation with selected role
  void _handleTestApp() {
    print('Test app button pressed. Selected role: $_selectedRole');
    if (_selectedRole != null) {
      String route;
      switch (_selectedRole!) {
        case UserRole.student:
          route = '/student-dashboard';
          break;
        case UserRole.teacher:
          route = '/teacher-dashboard';
          break;
        case UserRole.admin:
          route = '/admin-dashboard';
          break;
      }

      print('Navigating to test route: $route');
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
            (route) => false,
      ).catchError((error) {
        print('Test navigation error: $error');
      });
    } else {
      print('No role selected, cannot test app');
    }
  }
}