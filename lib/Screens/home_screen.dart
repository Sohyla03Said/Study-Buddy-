import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/language_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/language_selector.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _lessons = [];
  List<String> _enrolledLessonIds = [];
  bool _isLoadingLessons = false;
  final ApiService _apiService = ApiService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
      return;
    }
    await _fetchLessons();
  }

  Future<void> _fetchLessons() async {
    if (_isLoadingLessons) return;

    setState(() {
      _isLoadingLessons = true;
      _lessons = [];
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Fetch lessons from API
      final lessonsResponse = await _apiService.getLessons();

      if (authProvider.userRole == 'student') {
        // For students, also fetch enrolled lessons to filter them out
        try {
          final progressResponse = await _apiService.getProgress(authProvider.userModel?.uid ?? '');
          _enrolledLessonIds = (progressResponse as List<dynamic>)
              .map<String>((progress) => progress['lesson_id'].toString())
              .toList();
        } catch (e) {
          // If progress fetch fails, continue with empty enrolled lessons
          _enrolledLessonIds = [];
        }
      }

      setState(() {
        _lessons = List<Map<String, dynamic>>.from(lessonsResponse as List<dynamic>);
        _isLoadingLessons = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingLessons = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              Provider.of<LanguageProvider>(context, listen: false).isArabic
                  ? 'خطأ في جلب الدروس: ${e.toString()}'
                  : 'Error fetching lessons: ${e.toString()}',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _createNewLesson() async {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);

    // Show dialog to get lesson details
    String? title;
    String? content;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(languageProvider.isArabic ? 'إنشاء درس جديد' : 'Create New Lesson'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: languageProvider.isArabic ? 'عنوان الدرس' : 'Lesson Title',
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => title = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: languageProvider.isArabic ? 'محتوى الدرس' : 'Lesson Content',
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => content = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(languageProvider.isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (title != null && title!.isNotEmpty && content != null && content!.isNotEmpty) {
                try {
                  await _apiService.createLesson({
                    'title': title!,
                    'content': content!,
                  });

                  Navigator.pop(context);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(languageProvider.isArabic
                            ? 'تم إنشاء الدرس بنجاح'
                            : 'Lesson created successfully'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                    _fetchLessons(); // Refresh lessons
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(languageProvider.isArabic
                            ? 'خطأ في إنشاء الدرس: ${e.toString()}'
                            : 'Error creating lesson: ${e.toString()}'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                }
              }
            },
            child: Text(languageProvider.isArabic ? 'إنشاء' : 'Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _enrollInLesson(String lessonId, String lessonTitle) async {
    try {
      await _apiService.updateProgress(lessonId, 0.0); // Start with 0% progress

      if (mounted) {
        final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(languageProvider.isArabic
                ? 'تم التسجيل في الدرس بنجاح'
                : 'Successfully enrolled in lesson'),
            backgroundColor: AppColors.success,
          ),
        );
        _fetchLessons(); // Refresh lessons
      }
    } catch (e) {
      if (mounted) {
        final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(languageProvider.isArabic
                ? 'خطأ في التسجيل: ${e.toString()}'
                : 'Error enrolling: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.isArabic;

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Top Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await authProvider.signOut();
                        if (mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                                (route) => false,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.logout,
                          color: AppColors.error,
                          size: 24,
                        ),
                      ),
                    ),
                    const LanguageSelector(),
                  ],
                ),
                const SizedBox(height: 40),
                // Welcome Message
                Text(
                  authProvider.userModel != null
                      ? (isArabic
                      ? 'مرحباً ${authProvider.userModel!.email}!'
                      : 'Welcome ${authProvider.userModel!.email}!')
                      : (isArabic ? 'مرحباً!' : 'Welcome!'),
                  style: AppTextStyles.heading1.copyWith(
                    fontSize: 32,
                    color: AppColors.highContrastText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  authProvider.userRole == 'teacher'
                      ? (isArabic
                      ? 'إدارة دروسك هنا'
                      : 'Manage your lessons here')
                      : (isArabic
                      ? 'استكشف دروسك'
                      : 'Explore your lessons'),
                  style: AppTextStyles.body1.copyWith(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Action Button for Teachers
                if (authProvider.userRole == 'teacher')
                  CustomButton(
                    text: isArabic ? 'إنشاء درس جديد' : 'Create New Lesson',
                    onPressed: _createNewLesson,
                    height: 60,
                    width: 250,
                  ),
                const SizedBox(height: 20),
                // Refresh Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _isLoadingLessons ? null : _fetchLessons,
                      icon: _isLoadingLessons
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.refresh),
                      tooltip: isArabic ? 'تحديث' : 'Refresh',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Lessons List
                Expanded(
                  child: _isLoadingLessons
                      ? const Center(child: CircularProgressIndicator())
                      : _lessons.isEmpty
                      ? Center(
                    child: Text(
                      isArabic
                          ? 'لا توجد دروس متاحة'
                          : 'No lessons available',
                      style: AppTextStyles.body1.copyWith(
                        color: Colors.black54,
                      ),
                    ),
                  )
                      : ListView.builder(
                    itemCount: _lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = _lessons[index];
                      final lessonId = lesson['id'];
                      final isEnrolled = _enrolledLessonIds.contains(lessonId.toString());

                      return _buildLessonCard(
                        context,
                        lesson['title']?.toString() ?? 'Lesson ${index + 1}',
                        lesson['content']?.toString() ?? '',
                        lessonId.toString(),
                        authProvider.userRole == 'teacher',
                        isEnrolled,
                        isArabic,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(
      BuildContext context,
      String title,
      String description,
      String lessonId,
      bool isTeacher,
      bool isEnrolled,
      bool isArabic,
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: AppTextStyles.heading3.copyWith(fontSize: 18),
        ),
        subtitle: Text(
          description,
          style: AppTextStyles.body1.copyWith(fontSize: 14, color: Colors.black54),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isTeacher
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: () {
                // Navigate to lesson editing screen
                Navigator.pushNamed(
                  context,
                  '/lesson-edit',
                  arguments: {'lessonId': lessonId, 'title': title, 'content': description},
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: () {
                // Show delete confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(isArabic ? 'حذف الدرس' : 'Delete Lesson'),
                    content: Text(isArabic
                        ? 'هل أنت متأكد من حذف هذا الدرس؟'
                        : 'Are you sure you want to delete this lesson?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Implement lesson deletion
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isArabic
                                  ? 'سيتم إضافة حذف الدرس قريباً'
                                  : 'Lesson deletion coming soon'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        child: Text(isArabic ? 'حذف' : 'Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        )
            : isEnrolled
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.success),
          ),
          child: Text(
            isArabic ? 'مسجل' : 'Enrolled',
            style: TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : CustomButton(
          text: isArabic ? 'التسجيل' : 'Enroll',
          onPressed: () => _enrollInLesson(lessonId, title),
          width: 100,
          height: 40,
        ),
      ),
    );
  }
}