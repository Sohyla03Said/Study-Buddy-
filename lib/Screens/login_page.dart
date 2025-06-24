import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../models/user_model.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    // Clear any previous errors
    authProvider.clearError();

    // Attempt to sign in
    final success = await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
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
        // Show error message from AuthProvider
        final errorMessage = authProvider.errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage ?? (languageProvider.isArabic
                  ? 'فشل في تسجيل الدخول. تحقق من بياناتك.'
                  : 'Login failed. Please check your credentials.'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    // Clear any previous errors
    authProvider.clearError();

    final success = await authProvider.signInWithGoogle();

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
        // Show error message from AuthProvider
        final errorMessage = authProvider.errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage ?? (languageProvider.isArabic
                  ? 'فشل في تسجيل الدخول بواسطة Google'
                  : 'Google sign in failed'),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            Provider.of<LanguageProvider>(context, listen: false).isArabic
                ? 'يرجى إدخال البريد الإلكتروني أولاً'
                : 'Please enter your email first',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    final success = await authProvider.resetPassword(_emailController.text.trim());

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? (languageProvider.isArabic
                ? 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني'
                : 'Password reset link sent to your email')
                : (authProvider.errorMessage ?? (languageProvider.isArabic
                ? 'فشل في إرسال رابط إعادة تعيين كلمة المرور'
                : 'Failed to send password reset link')),
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  // UPDATED: Handle test app navigation with role from arguments or show dialog
  void _handleTestApp(UserRole? selectedRole) {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    if (selectedRole != null) {
      // If we have a selected role from role selection, navigate directly
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
      // Show selection dialog for test role (fallback when no role is passed)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          final isArabic = languageProvider.isArabic;
          return AlertDialog(
            title: Text(
              isArabic ? 'اختر نوع المستخدم' : 'Select User Type',
              style: AppTextStyles.heading2,
            ),
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
        tileColor: Colors.grey.withOpacity(0.1),
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
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

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.isArabic;

    // UPDATED: Get selected role from arguments
    final UserRole? selectedRole = ModalRoute.of(context)?.settings.arguments as UserRole?;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Content overlay
          Column(
            children: [
              // AppBar
              SafeArea(
                child: Container(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isArabic ? Icons.arrow_forward : Icons.arrow_back,
                          color: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
              ),
              // Main content
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: SingleChildScrollView(
                    child: Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),

                              // Welcome back text
                              Text(
                                isArabic ? 'مرحباً بعودتك!' : 'Welcome Back!',
                                style: AppTextStyles.heading1.copyWith(
                                  color: Colors.black,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0,
                                      color: Colors.black.withOpacity(0.5),
                                      offset: Offset(2.0, 2.0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedRole != null
                                    ? (selectedRole == UserRole.teacher
                                    ? (isArabic ? 'سجل دخولك كمعلم' : 'Sign in as a Teacher')
                                    : selectedRole == UserRole.student
                                    ? (isArabic ? 'سجل دخولك كطالب' : 'Sign in as a Student')
                                    : (isArabic ? 'سجل دخولك كمدير' : 'Sign in as an Admin'))
                                    : (isArabic ? 'سجل دخولك للمتابعة' : 'Sign in to continue'),
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.black.withOpacity(0.9),
                                  shadows: [
                                    Shadow(
                                      blurRadius: 5.0,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: Offset(1.0, 1.0),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Email field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                  decoration: InputDecoration(
                                    labelText: isArabic ? 'البريد الإلكتروني' : 'Email',
                                    prefixIcon: const Icon(Icons.email_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return isArabic
                                          ? 'يرجى إدخال البريد الإلكتروني'
                                          : 'Please enter your email';
                                    }
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return isArabic
                                          ? 'يرجى إدخال بريد إلكتروني صحيح'
                                          : 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Password field
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                                  decoration: InputDecoration(
                                    labelText: isArabic ? 'كلمة المرور' : 'Password',
                                    prefixIcon: const Icon(Icons.lock_outlined),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(color: AppColors.primary, width: 2),
                                    ),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return isArabic
                                          ? 'يرجى إدخال كلمة المرور'
                                          : 'Please enter your password';
                                    }
                                    if (value.length < 6) {
                                      return isArabic
                                          ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
                                          : 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Forgot password
                              Align(
                                alignment: isArabic ? Alignment.centerLeft : Alignment.centerRight,
                                child: TextButton(
                                  onPressed: authProvider.isLoading ? null : _handleForgotPassword,
                                  child: Text(
                                    isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                                    style: AppTextStyles.body2.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5.0,
                                          color: Colors.black.withOpacity(0.3),
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Login button
                              SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: authProvider.isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                      : Text(
                                    isArabic ? 'تسجيل الدخول' : 'Login',
                                    style: AppTextStyles.button.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // OR divider
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.black.withOpacity(0.7))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      isArabic ? 'أو' : 'OR',
                                      style: AppTextStyles.body2.copyWith(
                                        color: Colors.black,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 5.0,
                                            color: Colors.black.withOpacity(0.3),
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.black.withOpacity(0.7))),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // Google Sign In button
                              SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: authProvider.isLoading ? null : _handleGoogleSignIn,
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white.withOpacity(0.95),
                                    side: BorderSide(color: Colors.grey[300]!),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: authProvider.isLoading
                                      ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/google_logo.png',
                                        height: 24,
                                        width: 24,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Icon(Icons.g_mobiledata, size: 24, color: Colors.grey[600]);
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        isArabic ? 'الدخول بواسطة Google' : 'Sign in with Google',
                                        style: AppTextStyles.body1.copyWith(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // UPDATED: Test App button with role-specific text
                              SizedBox(
                                height: 56,
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () => _handleTestApp(selectedRole),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.orange),
                                    backgroundColor: Colors.orange.withOpacity(0.2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.bug_report, color: Colors.orange),
                                      const SizedBox(width: 12),
                                      Text(
                                        selectedRole != null
                                            ? (isArabic
                                            ? 'تجربة كـ${selectedRole == UserRole.teacher ? 'معلم' : selectedRole == UserRole.student ? 'طالب' : 'مدير'}'
                                            : 'Test as ${selectedRole == UserRole.teacher ? 'Teacher' : selectedRole == UserRole.student ? 'Student' : 'Admin'}')
                                            : (isArabic ? 'تجربة التطبيق' : 'Test App'),
                                        style: AppTextStyles.body1.copyWith(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),

                              // Don't have account
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isArabic ? 'ليس لديك حساب؟ ' : "Don't have an account? ",
                                    style: AppTextStyles.body2.copyWith(
                                      color: Colors.black,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 5.0,
                                          color: Colors.black.withOpacity(0.3),
                                          offset: Offset(1.0, 1.0),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // UPDATED: Pass selected role when navigating to signup
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/signup',
                                        arguments: selectedRole,
                                      );
                                    },
                                    child: Text(
                                      isArabic ? 'إنشاء حساب' : 'Sign Up',
                                      style: AppTextStyles.body2.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 5.0,
                                            color: Colors.black.withOpacity(0.3),
                                            offset: Offset(1.0, 1.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}