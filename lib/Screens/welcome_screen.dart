import 'package:edu/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/language_selector.dart';
import '../utils/colors.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final bool isArabic = languageProvider.isArabic;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: LanguageSelector(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Column(
              children: [
                // Image at the top with dynamic height
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5, // 50% of screen height
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/child.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                // Text, button, login link, and app info below
                Expanded(
                  child: SingleChildScrollView( // Add scrollable area
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isArabic
                                ? 'ابدأ رحلتك التعليمية,\nاجعلها ممتعة، اعمل بقلب,\nواصل التألق، واشرق كل يوم!'
                                : "LET'S START YOUR JOURNEY,\nMAKE IT FUN, WORK WITH HEART,\nZOOM TO THE TOP, AND SHINE\nEVERY DAY!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 40),
                          CustomButton(
                            text: isArabic ? 'ابدأ الآن' : "LET'S GET STARTED",
                            onPressed: () {
                              Navigator.pushNamed(context, '/role-selection');
                            },
                            height: 60,
                            width: 200,
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isArabic ? 'لديك حساب بالفعل؟ ' : 'Already have an account? ',
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: Text(
                                  isArabic ? 'تسجيل دخول' : 'Login',
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  isArabic ? 'تطبيق تعليمي شامل' : 'Comprehensive Learning App',
                                  style: AppTextStyles.body1.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  isArabic
                                      ? 'للمعلمين والطلاب - تعلم بطريقة تفاعلية وممتعة'
                                      : 'For Teachers and Students - Learn Interactively',
                                  style: AppTextStyles.caption.copyWith(
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}