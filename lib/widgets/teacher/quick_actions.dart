import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/text_styles.dart';
import '../teacher/dashboard_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        final isArabic = languageProvider.isArabic;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            DashboardCard(
              title: isArabic ? 'إنشاء درس' : 'Create Lesson',
              icon: Icons.add_circle,
              color: Colors.blue,
              onTap: () => Navigator.pushNamed(context, '/lessons-management'),
            ),
            DashboardCard(
              title: isArabic ? 'متابعة الطلاب' : 'Track Students',
              icon: Icons.trending_up,
              color: Colors.green,
              onTap: () => Navigator.pushNamed(context, '/student-progress'),
            ),
            DashboardCard(
              title: isArabic ? 'رفع المواد' : 'Upload Materials',
              icon: Icons.cloud_upload,
              color: Colors.orange,
              onTap: () => Navigator.pushNamed(context, '/materials-upload'),
            ),
            DashboardCard(
              title: isArabic ? 'تقييم الطلاب' : 'Assess Students',
              icon: Icons.assessment,
              color: Colors.purple,
              onTap: () => Navigator.pushNamed(context, '/assessments'),
            ),
            DashboardCard(
              title: isArabic ? 'إنشاء اختبار' : 'Create Quiz',
              icon: Icons.quiz,
              color: Colors.red,
              onTap: () => Navigator.pushNamed(context, '/quiz-creation'),
            ),
            DashboardCard(
              title: isArabic ? 'التقارير' : 'Reports',
              icon: Icons.bar_chart,
              color: Colors.teal,
              onTap: () => Navigator.pushNamed(context, '/reports'),
            ),
          ],
        );
      },
    );
  }
}