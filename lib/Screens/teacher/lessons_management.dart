import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';

class LessonsManagement extends StatefulWidget {
  const LessonsManagement({Key? key}) : super(key: key);

  @override
  State<LessonsManagement> createState() => _LessonsManagementState();
}

class _LessonsManagementState extends State<LessonsManagement> {
  final List<Lesson> _lessons = [
    Lesson(
      id: '1',
      title: 'Introduction to Mathematics',
      titleAr: 'مقدمة في الرياضيات',
      description: 'Basic mathematical concepts and operations',
      descriptionAr: 'المفاهيم والعمليات الرياضية الأساسية',
      duration: '45 min',
      studentsCount: 25,
      status: LessonStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Lesson(
      id: '2',
      title: 'Algebra Fundamentals',
      titleAr: 'أساسيات الجبر',
      description: 'Understanding algebraic expressions and equations',
      descriptionAr: 'فهم التعبيرات والمعادلات الجبرية',
      duration: '60 min',
      studentsCount: 30,
      status: LessonStatus.draft,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Lesson(
      id: '3',
      title: 'Geometry Basics',
      titleAr: 'أساسيات الهندسة',
      description: 'Shapes, angles, and geometric principles',
      descriptionAr: 'الأشكال والزوايا والمبادئ الهندسية',
      duration: '50 min',
      studentsCount: 28,
      status: LessonStatus.scheduled,
      createdAt: DateTime.now().add(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isArabic = languageProvider.isArabic;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: Text(
          isArabic ? 'إدارة الدروس' : 'Lessons Management',
          style: AppTextStyles.heading2.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            isArabic ? Icons.arrow_forward : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Header with stats
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      isArabic ? 'المنشور' : 'Published',
                      _lessons.where((l) => l.status == LessonStatus.published).length.toString(),
                      Colors.green,
                    ),
                    _buildStatItem(
                      isArabic ? 'المسودة' : 'Draft',
                      _lessons.where((l) => l.status == LessonStatus.draft).length.toString(),
                      Colors.orange,
                    ),
                    _buildStatItem(
                      isArabic ? 'المجدول' : 'Scheduled',
                      _lessons.where((l) => l.status == LessonStatus.scheduled).length.toString(),
                      Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Create Lesson Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              text: isArabic ? 'إنشاء درس جديد' : 'Create New Lesson',
              onPressed: () => _showCreateLessonDialog(context, isArabic),
              height: 50,
              width: double.infinity,
            ),
          ),

          const SizedBox(height: 20),

          // Lessons List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _lessons.length,
              itemBuilder: (context, index) {
                final lesson = _lessons[index];
                return _buildLessonCard(lesson, isArabic, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              value,
              style: AppTextStyles.heading2.copyWith(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(Lesson lesson, bool isArabic, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isArabic ? lesson.titleAr : lesson.title,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                _buildStatusChip(lesson.status, isArabic),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? lesson.descriptionAr : lesson.description,
              style: AppTextStyles.body2.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      lesson.duration,
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.people, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${lesson.studentsCount} ${isArabic ? 'طالب' : 'students'}',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  isArabic ? 'تحرير' : 'Edit',
                  Icons.edit,
                  AppColors.primary,
                      () => _editLesson(lesson),
                ),
                _buildActionButton(
                  isArabic ? 'مشاهدة' : 'View',
                  Icons.visibility,
                  Colors.green,
                      () => _viewLesson(lesson),
                ),
                _buildActionButton(
                  isArabic ? 'حذف' : 'Delete',
                  Icons.delete,
                  Colors.red,
                      () => _deleteLesson(lesson.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(LessonStatus status, bool isArabic) {
    String text;
    Color color;

    switch (status) {
      case LessonStatus.published:
        text = isArabic ? 'منشور' : 'Published';
        color = Colors.green;
        break;
      case LessonStatus.draft:
        text = isArabic ? 'مسودة' : 'Draft';
        color = Colors.orange;
        break;
      case LessonStatus.scheduled:
        text = isArabic ? 'مجدول' : 'Scheduled';
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: AppTextStyles.body2.copyWith(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: Text(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateLessonDialog(BuildContext context, bool isArabic) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isArabic ? 'إنشاء درس جديد' : 'Create New Lesson',
          style: AppTextStyles.heading3,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'عنوان الدرس' : 'Lesson Title',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: isArabic ? 'وصف الدرس' : 'Lesson Description',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'مدة الدرس' : 'Duration (e.g., 45 min)',
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                _createLesson(
                  titleController.text,
                  descriptionController.text,
                  durationController.text.isEmpty ? '45 min' : durationController.text,
                );
                Navigator.pop(context);
              }
            },
            child: Text(isArabic ? 'إنشاء' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _createLesson(String title, String description, String duration) {
    setState(() {
      _lessons.add(
        Lesson(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          titleAr: title, // In real app, you'd translate or get Arabic input
          description: description,
          descriptionAr: description,
          duration: duration,
          studentsCount: 0,
          status: LessonStatus.draft,
          createdAt: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lesson created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editLesson(Lesson lesson) {
    // Navigate to lesson editor or show edit dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit lesson: ${lesson.title}')),
    );
  }

  void _viewLesson(Lesson lesson) {
    // Navigate to lesson viewer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View lesson: ${lesson.title}')),
    );
  }

  void _deleteLesson(String lessonId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Lesson'),
        content: const Text('Are you sure you want to delete this lesson?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _lessons.removeWhere((lesson) => lesson.id == lessonId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Lesson deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Lesson Model
class Lesson {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final String duration;
  final int studentsCount;
  final LessonStatus status;
  final DateTime createdAt;

  Lesson({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.duration,
    required this.studentsCount,
    required this.status,
    required this.createdAt,
  });
}

enum LessonStatus { published, draft, scheduled }