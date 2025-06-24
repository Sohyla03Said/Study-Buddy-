import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/teacher/dashboard_card.dart';
import '../../widgets/teacher/quick_actions.dart';
import '../../widgets/teacher/progress_chart.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.isArabic;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            // Background Image for AppBar
            Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.9),
                    AppColors.primary.withOpacity(0.7)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            // AppBar Content
            AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                isArabic ? 'لوحة المعلم' : 'Teacher Dashboard',
                style: AppTextStyles.heading2.copyWith(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                  onPressed: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Message with Background Image
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/background.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.8),
                              AppColors.primary.withOpacity(0.6)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isArabic ? 'مرحباً بك، أستاذ أحمد' : 'Welcome back, Teacher!',
                              style: AppTextStyles.heading2.copyWith(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Flexible(
                              child: Text(
                                isArabic
                                    ? 'لديك 3 مهام جديدة و 12 طالب في انتظار التقييم'
                                    : 'You have 3 new tasks and 12 students awaiting assessment',
                                style: AppTextStyles.body1.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Stats with Background Images
            Row(
              children: [
                Expanded(
                  child: _buildStatCardWithBackground(
                    title: isArabic ? 'الطلاب' : 'Students',
                    value: '124',
                    icon: Icons.people,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCardWithBackground(
                    title: isArabic ? 'الدروس' : 'Lessons',
                    value: '28',
                    icon: Icons.book,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildStatCardWithBackground(
                    title: isArabic ? 'الاختبارات' : 'Quizzes',
                    value: '15',
                    icon: Icons.quiz,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCardWithBackground(
                    title: isArabic ? 'المواد' : 'Materials',
                    value: '42',
                    icon: Icons.folder,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Progress Chart with Background Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Background Image
                    Image.asset(
                      'assets/images/background.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 300,
                    ),
                    // White Overlay for readability
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'إحصائيات الأسبوع' : 'Weekly Analytics',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const ProgressChart(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quick Actions
            Text(
              isArabic ? 'الإجراءات السريعة' : 'Quick Actions',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildActionCardWithBackground(
                  title: isArabic ? 'إنشاء درس' : 'Create Lesson',
                  icon: Icons.add_circle,
                  color: Colors.blue,
                  onTap: () => Navigator.pushNamed(context, '/lessons-management'),
                ),
                _buildActionCardWithBackground(
                  title: isArabic ? 'متابعة الطلاب' : 'Track Students',
                  icon: Icons.trending_up,
                  color: Colors.green,
                  onTap: () => Navigator.pushNamed(context, '/student-progress'),
                ),
                _buildActionCardWithBackground(
                  title: isArabic ? 'رفع المواد' : 'Upload Materials',
                  icon: Icons.cloud_upload,
                  color: Colors.orange,
                  onTap: () => Navigator.pushNamed(context, '/materials-upload'),
                ),
                _buildActionCardWithBackground(
                  title: isArabic ? 'تقييم الطلاب' : 'Assess Students',
                  icon: Icons.assessment,
                  color: Colors.purple,
                  onTap: () => Navigator.pushNamed(context, '/assessments'),
                ),
                _buildActionCardWithBackground(
                  title: isArabic ? 'إنشاء اختبار' : 'Create Quiz',
                  icon: Icons.quiz,
                  color: Colors.red,
                  onTap: () => Navigator.pushNamed(context, '/quiz-creation'),
                ),
                _buildActionCardWithBackground(
                  title: isArabic ? 'التقارير' : 'Reports',
                  icon: Icons.bar_chart,
                  color: Colors.teal,
                  onTap: () => Navigator.pushNamed(context, '/reports'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Activities with Background Image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Background Image
                    Image.asset(
                      'assets/images/background.jpg',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 220,
                    ),
                    // White Overlay for readability
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isArabic ? 'الأنشطة الأخيرة' : 'Recent Activities',
                            style: AppTextStyles.heading3.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(
                            3,
                                (index) => _buildActivityItem(
                              isArabic,
                              index == 0
                                  ? (isArabic ? 'أحمد محمد أكمل الاختبار' : 'Ahmed Mohamed completed quiz')
                                  : index == 1
                                  ? (isArabic ? 'تم رفع مادة جديدة' : 'New material uploaded')
                                  : (isArabic ? 'فاطمة علي طلبت مساعدة' : 'Fatma Ali requested help'),
                              index == 0 ? '2 ساعات' : index == 1 ? '4 ساعات' : '6 ساعات',
                              isArabic ? '2 hours ago' : index == 1 ? '4 hours ago' : '6 hours ago',
                            ),
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
      ),
    );
  }

  Widget _buildStatCardWithBackground({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background Image
            Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            // Color Overlay
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: color, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    value,
                    style: AppTextStyles.heading2.copyWith(
                      color: color,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppTextStyles.body2.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCardWithBackground({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              // White Overlay
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                ),
              ),
              // Content
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            icon,
                            color: color,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          title,
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(bool isArabic, String activity, String timeAr, String timeEn) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity,
                  style: AppTextStyles.body1,
                ),
                Text(
                  isArabic ? timeAr : timeEn,
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.grey[600],
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