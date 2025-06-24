import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../models/user_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/language_selector.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  // Handle test app navigation - UPDATED to use selected role
  void _handleTestApp(UserRole? selectedRole) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    if (selectedRole != null) {
      // If we have a selected role, navigate directly to that dashboard
      String route;
      switch (selectedRole) {
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

      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
            (route) => false,
      );
    } else {
      // Show selection dialog for test role (fallback)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final isArabic = languageProvider.isArabic;
          return AlertDialog(
            title: Text(
              isArabic ? 'اختر نوع المستخدم' : 'Select User Type',
              style: AppTextStyles.heading2.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.black87,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTestRoleOption(
                  icon: Icons.person,
                  title: isArabic ? 'طالب' : 'Student',
                  route: '/student-dashboard',
                  isArabic: isArabic,
                ),
                _buildTestRoleOption(
                  icon: Icons.school,
                  title: isArabic ? 'معلم' : 'Teacher',
                  route: '/teacher-dashboard',
                  isArabic: isArabic,
                ),
                _buildTestRoleOption(
                  icon: Icons.admin_panel_settings,
                  title: isArabic ? 'مدير' : 'Admin',
                  route: '/admin-dashboard',
                  isArabic: isArabic,
                ),
                _buildTestRoleOption(
                  icon: Icons.home,
                  title: isArabic ? 'الرئيسية' : 'Home',
                  route: '/home',
                  isArabic: isArabic,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildTestRoleOption({
    required IconData icon,
    required String title,
    required String route,
    required bool isArabic,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: Colors.white.withOpacity(0.1),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.pushNamedAndRemoveUntil(
            context,
            route,
                (route) => false,
          );
        },
      ),
    );
  }

  // Validation methods
  String? _validateFullName(String? value) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isArabic = languageProvider.isArabic;

    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال الاسم الكامل' : 'Please enter your full name';
    }
    if (value.length < 2) {
      return isArabic ? 'الاسم يجب أن يكون حرفين على الأقل' : 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isArabic = languageProvider.isArabic;

    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال البريد الإلكتروني' : 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return isArabic ? 'يرجى إدخال بريد إلكتروني صحيح' : 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isArabic = languageProvider.isArabic;

    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال كلمة المرور' : 'Please enter your password';
    }
    if (value.length < 6) {
      return isArabic ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' : 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    final isArabic = languageProvider.isArabic;

    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى تأكيد كلمة المرور' : 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return isArabic ? 'كلمات المرور غير متطابقة' : 'Passwords do not match';
    }
    return null;
  }

  // Handle signup
  Future<void> _handleSignUp(UserRole? selectedRole) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    // Clear any previous errors
    authProvider.clearError();

    // Attempt to sign up
    final success = await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      fullName: _fullNameController.text.trim(),
      role: selectedRole ?? UserRole.student,
    );

    if (mounted) {
      if (success) {
        // Navigate based on user role
        final userRole = authProvider.userRole;
        if (userRole == 'student') {
          Navigator.pushReplacementNamed(context, '/student-dashboard');
        } else if (userRole == 'teacher') {
          Navigator.pushReplacementNamed(context, '/teacher-dashboard');
        } else if (userRole == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Show error message
        final errorMessage = authProvider.errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage ?? (languageProvider.isArabic
                  ? 'فشل في إنشاء الحساب'
                  : 'Sign up failed'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isArabic = languageProvider.isArabic;

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
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withAlpha(76),
                  Colors.black.withAlpha(153),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(229),
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
                      const SizedBox(height: 40),
                      Text(
                        isArabic ? 'إنشاء حساب جديد' : 'Create Account',
                        style: AppTextStyles.heading1.copyWith(
                          fontSize: 32,
                          color: AppColors.highContrastText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        selectedRole != null
                            ? (selectedRole == UserRole.teacher
                            ? (isArabic ? 'انضم كمعلم' : 'Join as a Teacher')
                            : selectedRole == UserRole.student
                            ? (isArabic ? 'انضم كطالب' : 'Join as a Student')
                            : (isArabic ? 'انضم كمدير' : 'Join as an Admin'))
                            : (isArabic ? 'انضم إلينا اليوم' : 'Join us today'),
                        style: AppTextStyles.body1.copyWith(
                          color: Colors.white.withAlpha(179),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      CustomTextField(
                        label: isArabic ? 'الاسم الكامل' : 'Full Name',
                        hint: isArabic ? 'أدخل اسمك الكامل' : 'Enter your full name',
                        controller: _fullNameController,
                        prefixIcon: Icons.person_outline,
                        validator: _validateFullName,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: isArabic ? 'البريد الإلكتروني' : 'Email',
                        hint: isArabic ? 'أدخل بريدك الإلكتروني' : 'Enter your email',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: isArabic ? 'كلمة المرور' : 'Password',
                        hint: isArabic ? 'أدخل كلمة المرور' : 'Enter your password',
                        controller: _passwordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password',
                        hint: isArabic ? 'أعد إدخال كلمة المرور' : 'Re-enter your password',
                        controller: _confirmPasswordController,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        validator: _validateConfirmPassword,
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: isArabic ? 'إنشاء حساب' : 'Sign Up',
                        onPressed: authProvider.isLoading
                            ? null
                            : () {
                          if (_formKey.currentState!.validate()) {
                            _handleSignUp(selectedRole);
                          }
                        },
                        height: 60,
                        enabled: !authProvider.isLoading,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: Colors.white24)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              isArabic ? 'أو' : 'OR',
                              style: TextStyle(
                                color: Colors.white.withAlpha(179),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider(color: Colors.white24)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Test App button - UPDATED to use selected role
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange, width: 2),
                          color: Colors.orange.withOpacity(0.1),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => _handleTestApp(selectedRole),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bug_report,
                                  color: Colors.orange,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  selectedRole != null
                                      ? (isArabic
                                      ? 'تجربة كـ${selectedRole == UserRole.teacher ? 'معلم' : selectedRole == UserRole.student ? 'طالب' : 'مدير'}'
                                      : 'Test as ${selectedRole == UserRole.teacher ? 'Teacher' : selectedRole == UserRole.student ? 'Student' : 'Admin'}')
                                      : (isArabic ? 'تجربة التطبيق' : 'Test App'),
                                  style: AppTextStyles.body1.copyWith(
                                    color: Colors.orange,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic ? 'لديك حساب بالفعل؟ ' : 'Already have an account? ',
                            style: AppTextStyles.body1.copyWith(
                              color: Colors.white.withAlpha(179),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: Text(
                              isArabic ? 'تسجيل الدخول' : 'Sign In',
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}