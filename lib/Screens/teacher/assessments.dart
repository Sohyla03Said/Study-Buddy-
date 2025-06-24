import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';

class Assessments extends StatefulWidget {
  const Assessments({Key? key}) : super(key: key);

  @override
  State<Assessments> createState() => _AssessmentsState();
}

class _AssessmentsState extends State<Assessments> {
  final List<Assessment> _assessments = [
    Assessment(
      id: '1',
      studentName: 'Ahmed Mohamed',
      studentNameAr: 'أحمد محمد',
      course: 'Mathematics',
      courseAr: 'الرياضيات',
      score: 85.5,
      comments: 'Good progress in algebra',
      commentsAr: 'تقدم جيد في الجبر',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Assessment(
      id: '2',
      studentName: 'Fatma Ali',
      studentNameAr: 'فاطمة',
      course: 'Geometry',
      courseAr: 'الهندسة',
      score: 92.3,
      comments: 'Excellent understanding of shapes',
      commentsAr: 'فهم ممتاز للأشكال',
      date: DateTime.now().subtract(const Duration(days: 1)),
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
          isArabic ? 'تقييم الطلاب' : 'Student Assessments',
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
                  isArabic ? 'التقييمات' : 'Assessments',
                  _assessments.length.toString(),
                  Icons.assessment,
                ),
                _buildStatItem(
                  isArabic ? 'المعدل' : 'Avg Score',
                  '${(_assessments.fold<double>(0, (sum, item) => sum + item.score) / _assessments.length).toStringAsFixed(1)}%',
                  Icons.star,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              text: isArabic ? 'إنشاء تقييم جديد' : 'Create New Assessment',
              onPressed: () => _showCreateAssessmentDialog(context, isArabic),
              height: 50,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _assessments.length,
              itemBuilder: (context, index) {
                final assessment = _assessments[index];
                return _buildAssessmentCard(assessment, isArabic);
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

  Widget _buildAssessmentCard(Assessment assessment, bool isArabic) {
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
                    isArabic ? assessment.studentNameAr : assessment.studentName,
                    style: AppTextStyles.heading3.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  '${assessment.score.toStringAsFixed(1)}%',
                  style: AppTextStyles.heading3.copyWith(
                    color: assessment.score >= 80 ? Colors.green : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? assessment.courseAr : assessment.course,
              style: AppTextStyles.body2.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isArabic ? assessment.commentsAr : assessment.comments,
              style: AppTextStyles.body2.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  isArabic ? 'تحرير' : 'Edit',
                  Icons.edit,
                  Colors.blue,
                      () => _editAssessment(assessment),
                ),
                _buildActionButton(
                  isArabic ? 'حذف' : 'Delete',
                  Icons.delete,
                  Colors.red,
                      () => _deleteAssessment(assessment.id),
                ),
              ],
            ),
          ],
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

  void _showCreateAssessmentDialog(BuildContext context, bool isArabic) {
    final studentController = TextEditingController();
    final courseController = TextEditingController();
    final scoreController = TextEditingController();
    final commentsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isArabic ? 'إنشاء تقييم جديد' : 'Create New Assessment',
          style: AppTextStyles.heading3,
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: studentController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'اسم الطالب' : 'Student Name',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: courseController,
                decoration: InputDecoration(
                  labelText: isArabic ? 'المادة' : 'Course',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: scoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isArabic ? 'الدرجة' : 'Score (%)',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: isArabic ? 'التعليقات' : 'Comments',
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
              final scoreText = scoreController.text.trim();
              double? score;
              if (scoreText.isNotEmpty) {
                try {
                  score = double.parse(scoreText);
                  if (score < 0 || score > 100) score = null; // Invalid range
                } catch (e) {
                  score = null; // Invalid format
                  print('Parse error for score: $scoreText, error: $e');
                }
              }
              if (studentController.text.isNotEmpty && score != null) {
                _createAssessment(studentController.text, courseController.text, score, commentsController.text);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isArabic ? 'يرجى إدخال درجة صالحة (0-100)' : 'Please enter a valid score (0-100)'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(isArabic ? 'إنشاء' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _createAssessment(String studentName, String course, double score, String comments) {
    setState(() {
      _assessments.add(
        Assessment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          studentName: studentName,
          studentNameAr: studentName,
          course: course,
          courseAr: course,
          score: score,
          comments: comments,
          commentsAr: comments,
          date: DateTime.now(),
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Assessment created successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _editAssessment(Assessment assessment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit assessment for ${assessment.studentName}')),
    );
  }

  void _deleteAssessment(String assessmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Assessment'),
        content: const Text('Are you sure you want to delete this assessment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _assessments.removeWhere((assessment) => assessment.id == assessmentId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assessment deleted successfully!'),
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

class Assessment {
  final String id;
  final String studentName;
  final String studentNameAr;
  final String course;
  final String courseAr;
  final double score;
  final String comments;
  final String commentsAr;
  final DateTime date;

  Assessment({
    required this.id,
    required this.studentName,
    required this.studentNameAr,
    required this.course,
    required this.courseAr,
    required this.score,
    required this.comments,
    required this.commentsAr,
    required this.date,
  });
}