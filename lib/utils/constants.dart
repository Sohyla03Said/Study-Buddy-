class AppConstants {
  // Firebase Collection Names
  static const String usersCollection = 'users';
  static const String lessonsCollection = 'lessons';
  static const String enrollmentsCollection = 'enrollments';

  // Routes
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String signupRoute = '/signup';
  static const String welcomeRoute = '/welcome';
  static const String roleSelectionRoute = '/role-selection';
  static const String welcomePageRoute = '/welcome-page';

  // Asset Paths
  static const String backgroundImage = 'asset/images/background.jpg';

  // Validation Constraints
  static const int minPasswordLength = 6;
  static const int minDisplayNameLength = 2;

  // Default Values
  static const String defaultLanguageCode = 'en';
  static const String defaultFontFamilyEn = 'Roboto';
  static const String defaultFontFamilyAr = 'Cairo';
}