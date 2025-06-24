# Study-Buddy-
Educational Platform Application

# Overview
This repository contains the source code for an educational platform application developed using Flutter. The app is designed to enhance the learning and teaching experience by providing a comprehensive suite of tools for students and teachers. It supports role-based access, multi-language capabilities, and a responsive user interface tailored for various devices.

# Features
- Student Dashboard: Access personalized learning progress, upcoming assignments, and educational resources.
- Teacher Dashboard: Manage assessments, monitor student progress, and upload teaching materials.
- Lessons Management: Create, organize, and update lesson plans with ease.
- Materials Upload: Upload documents, videos, and other resources for student access.
- Quiz Creation: Design interactive quizzes with multiple question types and automatic grading.
- Student Progress Tracking: Detailed analytics and reports on student performance.
- Multi-Language Support: Seamlessly switch between languages using the built-in language selector.
- Authentication: Secure login and signup pages with role-based access control (student/teacher).
- Responsive Design: Optimized for mobile, tablet, and desktop screens.
- Offline Mode: Basic functionality available offline with data syncing when online.

# Project Structure
- lib/: Main application source code.
- l10n/: Localization files (e.g., app_ar.arb, app_en.arb) for multi-language support.
- models/: Data models defining the structure of users and other entities (e.g., user_model.dart).
- providers/: State management providers for authentication and language settings (e.g., auth_provider.dart, language_provider.dart).
- Screens/: Screen-specific Dart files for various app functionalities (e.g., student_dashboard.dart, teacher_dashboard.dart, quiz_creation.dart).
- services/: API service implementations for backend communication (e.g., api_service.dart).
- utils/: Utility files for colors, constants, and text styles (e.g., colors.dart, constants.dart, text_styles.dart).
- widgets/: Reusable custom widgets for UI consistency (e.g., custom_button.dart, custom_text_field.dart, language_selector.dart).
- main.dart: Entry point of the Flutter application.



# Installation
Prerequisites: Ensure Flutter is installed on your system. Follow the official Flutter installation guide for setup instructions.
Clone the Repository:git clone <repository-url>

Navigate to Project Directory:cd <project-directory>

Install Dependencies:flutter pub get

Run the Application:flutter run


- Optional - IDE Setup: Use Visual Studio Code or Android Studio with the Flutter plugin for an enhanced development experience.

# Usage
Launch the app and select your role (student or teacher) on the role selection screen.
Log in with your credentials or sign up for a new account using the authentication pages.
Navigate through the dashboard to access features like lessons, quizzes, and progress tracking.
Use the language selector to switch languages and explore offline capabilities when internet access is limited.

# Demo Video
Check out the demo video to see the app in action:
Description: This video showcases the student and teacher dashboards, quiz creation process, materials upload, and multi-language switching. Recorded on June 24, 2025, at 05:29 PM EEST.

Contributing
Contributions are highly encouraged! Please fork the repository and submit pull requests with your enhancements. Follow the existing code style, write unit tests, and include detailed documentation for new features. Open an issue for discussions or bug reports before starting significant changes.
