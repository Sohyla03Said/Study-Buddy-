import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../models/user_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/language_selector.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.isArabic;

    // Get the selected role from navigation arguments
    final UserRole? selectedRole = ModalRoute.of(context)?.settings.arguments as UserRole?;

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
                  // Top Navigation
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
                        // Role Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              selectedRole == UserRole.teacher
                                  ? 'assets/images/teacher.png'
                                  : 'assets/images/student.png',
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Welcome Message
                        Text(
                          selectedRole == UserRole.teacher
                              ? (isArabic ? 'أهلاً بك كمعلم!' : 'Welcome Teacher!')
                              : (isArabic ? 'أهلاً بك كطالب!' : 'Welcome Student!'),
                          style: AppTextStyles.heading1.copyWith(
                            fontSize: 36,
                            color: AppColors.highContrastText,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Role Description
                        Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                selectedRole == UserRole.teacher
                                    ? (isArabic
                                    ? 'كمعلم، يمكنك:'
                                    : 'As a Teacher, you can:')
                                    : (isArabic
                                    ? 'كطالب، يمكنك:'
                                    : 'As a Student, you can:'),
                                style: AppTextStyles.heading3.copyWith(
                                  fontSize: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ...(_getRoleFeatures(selectedRole, isArabic))
                                  .map((feature) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: AppColors.success,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        feature,
                                        style: AppTextStyles.body1.copyWith(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),

                        const SizedBox(height: 50),

                        // Action Buttons
                        Column(
                          children: [
                            CustomButton(
                              text: isArabic ? 'إنشاء حساب جديد' : 'Create New Account',
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/signup',
                                  arguments: selectedRole,
                                );
                              },
                              height: 60,
                              width: 280,
                            ),
                            const SizedBox(height: 16),
                            CustomButton(
                              text: isArabic ? 'لدي حساب بالفعل' : 'I Already Have Account',
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              },
                              isSecondary: true,
                              height: 60,
                              width: 280,
                            ),
                          ],
                        ),
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

  List<String> _getRoleFeatures(UserRole? role, bool isArabic) {
    if (role == UserRole.teacher) {
      return isArabic
          ? [
        'إنشاء وإدارة الدروس',
        'متابعة تقدم الطلاب',
        'رفع المواد التعليمية',
        'تقييم الطلاب',
        'إنشاء الاختبارات',
      ]
          : [
        'Create and manage lessons',
        'Track student progress',
        'Upload educational materials',
        'Assess students',
        'Create quizzes and tests',
      ];
    } else {
      return isArabic
          ? [
        'الوصول إلى الدروس التفاعلية',
        'متابعة التقدم الشخصي',
        'حل الاختبارات والواجبات',
        'التفاعل مع المعلمين',
        'الحصول على الشهادات',
      ]
          : [
        'Access interactive lessons',
        'Track personal progress',
        'Take quizzes and assignments',
        'Interact with teachers',
        'Earn certificates',
      ];
    }
  }
}