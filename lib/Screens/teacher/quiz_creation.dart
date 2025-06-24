import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';

class QuizCreation extends StatefulWidget {
  const QuizCreation({Key? key}) : super(key: key);

  @override
  State<QuizCreation> createState() => _QuizCreationState();
}

class _QuizCreationState extends State<QuizCreation> {
  final List<Quiz> _quizzes = [
    Quiz(
      id: '1',
      title: 'Mathematics Quiz 1',
      titleAr: 'اختبار الرياضيات 1',
      description: 'Algebra and basic operations',
      descriptionAr: 'الجبر والعمليات الأساسية',
      questionsCount: 10,
      duration: '30 min',
      status: QuizStatus.draft,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Quiz(
      id: '2',
      title: 'Geometry Quiz',
      titleAr: 'اختبار الهندسة',
      description: 'Shapes and angles',
      descriptionAr: 'الأشكال والزوايا',
      questionsCount: 15,
      duration: '45 min',
      status: QuizStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
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
          isArabic ? 'إنشاء الاختبارات' : 'Quiz Creation',
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  isArabic ? 'الاختبارات' : 'Quizzes',
                  _quizzes.length.toString(),
                  Icons.quiz,
                ),
                _buildStatItem(
                  isArabic ? 'منشور' : 'Published',
                  _quizzes.where((q) => q.status == QuizStatus.published).length.toString(),
                  Icons.check_circle,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Create Quiz Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              text: isArabic ? 'إنشاء اختبار جديد' : 'Create New Quiz',
              onPressed: () => _showCreateQuizDialog(context, isArabic),
              height: 50,
              width: double.infinity,
            ),
          ),

          const SizedBox(height: 20),

          // Quizzes List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _quizzes.length,
              itemBuilder: (context, index) {
                final quiz = _quizzes[index];
                return _buildQuizCard(quiz, isArabic);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.heading2.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
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

  Widget _buildQuizCard(Quiz quiz, bool isArabic) {
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
                    isArabic ? quiz.titleAr : quiz.title,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                _buildStatusChip(quiz.status, isArabic),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? quiz.descriptionAr : quiz.description,
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
                    Icon(Icons.question_answer, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${quiz.questionsCount} ${isArabic ? 'سؤال' : 'questions'}',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      quiz.duration,
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
                      () => _editQuiz(quiz),
                ),
                _buildActionButton(
                  isArabic ? 'مشاهدة' : 'View',
                  Icons.visibility,
                  Colors.green,
                      () => _viewQuiz(quiz),
                ),
                _buildActionButton(
                  isArabic ? 'حذف' : 'Delete',
                  Icons.delete,
                  Colors.red,
                      () => _deleteQuiz(quiz.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(QuizStatus status, bool isArabic) {
    String text;
    Color color;

    switch (status) {
      case QuizStatus.published:
        text = isArabic ? 'منشور' : 'Published';
        color = Colors.green;
        break;
      case QuizStatus.draft:
        text = isArabic ? 'مسودة' : 'Draft';
        color = Colors.orange;
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

  void _showCreateQuizDialog(BuildContext context, bool isArabic) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final questionsController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isArabic ? 'إنشاء اختبار جديد' : 'Create New Quiz',
          style: AppTextStyles.heading3,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'عنوان الاختبار' : 'Quiz Title',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: isArabic ? 'وصف الاختبار' : 'Quiz Description',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: questionsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isArabic ? 'عدد الأسئلة' : 'Number of Questions',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'المدة' : 'Duration (e.g., 30 min)',
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
              if (titleController.text.isNotEmpty && questionsController.text.isNotEmpty) {
                _createQuiz(
                  titleController.text,
                  descriptionController.text,
                  int.parse(questionsController.text),
                  durationController.text.isEmpty ? '30 min' : durationController.text,
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

  void _createQuiz(String title, String description, int questionsCount, String duration) {
    setState(() {
      _quizzes.add(
        Quiz(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          titleAr: title,
          description: description,
          descriptionAr: description,
          questionsCount: questionsCount,
          duration: duration,
          status: QuizStatus.draft,
          createdAt: DateTime.now(),
        ),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Quiz created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editQuiz(Quiz quiz) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit quiz: ${quiz.title}')),
    );
  }

  void _viewQuiz(Quiz quiz) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View quiz: ${quiz.title}')),
    );
  }

  void _deleteQuiz(String quizId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text('Are you sure you want to delete this quiz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _quizzes.removeWhere((quiz) => quiz.id == quizId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quiz deleted successfully!'),
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

// Quiz Model
class Quiz {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final int questionsCount;
  final String duration;
  final QuizStatus status;
  final DateTime createdAt;

  Quiz({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.questionsCount,
    required this.duration,
    required this.status,
    required this.createdAt,
  });
}

enum QuizStatus { published, draft }