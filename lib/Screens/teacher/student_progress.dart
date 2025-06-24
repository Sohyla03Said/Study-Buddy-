import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class StudentProgress extends StatefulWidget {
  const StudentProgress({Key? key}) : super(key: key);

  @override
  State<StudentProgress> createState() => _StudentProgressState();
}

class _StudentProgressState extends State<StudentProgress> {
  String _selectedFilter = 'all';

  final List<StudentData> _students = [
    StudentData(
      id: '1',
      name: 'Ahmed Mohamed',
      nameAr: 'أحمد محمد',
      email: 'ahmed@example.com',
      avatar: 'assets/images/student.png',
      completedLessons: 15,
      totalLessons: 20,
      averageScore: 85.5,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
      status: StudentStatus.active,
      progressData: [78, 82, 85, 88, 85],
    ),
    StudentData(
      id: '2',
      name: 'Fatma Ali',
      nameAr: 'فاطمة علي',
      email: 'fatma@example.com',
      avatar: 'assets/images/student.png',
      completedLessons: 18,
      totalLessons: 20,
      averageScore: 92.3,
      lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
      status: StudentStatus.active,
      progressData: [85, 88, 90, 91, 92],
    ),
    StudentData(
      id: '3',
      name: 'Omar Hassan',
      nameAr: 'عمر حسن',
      email: 'omar@example.com',
      avatar: 'assets/images/student.png',
      completedLessons: 8,
      totalLessons: 20,
      averageScore: 65.8,
      lastActive: DateTime.now().subtract(const Duration(days: 3)),
      status: StudentStatus.struggling,
      progressData: [70, 68, 65, 62, 66],
    ),
    StudentData(
      id: '4',
      name: 'Sara Mahmoud',
      nameAr: 'سارة محمود',
      email: 'sara@example.com',
      avatar: 'assets/images/student.png',
      completedLessons: 20,
      totalLessons: 20,
      averageScore: 96.7,
      lastActive: DateTime.now().subtract(const Duration(hours: 1)),
      status: StudentStatus.excellent,
      progressData: [92, 94, 95, 96, 97],
    ),
  ];

  List<StudentData> get _filteredStudents {
    if (_selectedFilter == 'all') return _students;

    final status = StudentStatus.values.firstWhere(
          (s) => s.toString().split('.').last == _selectedFilter,
    );
    return _students.where((student) => student.status == status).toList();
  }

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
          isArabic ? 'متابعة تقدم الطلاب' : 'Student Progress',
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
          // Stats Header
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
                      isArabic ? 'إجمالي الطلاب' : 'Total Students',
                      _students.length.toString(),
                      Icons.people,
                    ),
                    _buildStatItem(
                      isArabic ? 'نشط' : 'Active',
                      _students.where((s) => s.status == StudentStatus.active).length.toString(),
                      Icons.trending_up,
                    ),
                    _buildStatItem(
                      isArabic ? 'يحتاج مساعدة' : 'Need Help',
                      _students.where((s) => s.status == StudentStatus.struggling).length.toString(),
                      Icons.help_outline,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Filter Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('all', isArabic ? 'الكل' : 'All', isArabic),
                  _buildFilterChip('active', isArabic ? 'نشط' : 'Active', isArabic),
                  _buildFilterChip('excellent', isArabic ? 'ممتاز' : 'Excellent', isArabic),
                  _buildFilterChip('struggling', isArabic ? 'يحتاج مساعدة' : 'Struggling', isArabic),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Students List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredStudents.length,
              itemBuilder: (context, index) {
                final student = _filteredStudents[index];
                return _buildStudentCard(student, isArabic);
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFilterChip(String value, String label, bool isArabic) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.body1.copyWith(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStudentCard(StudentData student, bool isArabic) {
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
          children: [
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(student.avatar),
                ),
                const SizedBox(width: 16),

                // Student Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? student.nameAr : student.name,
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        student.email,
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildStatusBadge(student.status, isArabic),
                    ],
                  ),
                ),

                // Score
                Column(
                  children: [
                    Text(
                      '${student.averageScore.toStringAsFixed(1)}%',
                      style: AppTextStyles.heading2.copyWith(
                        color: _getScoreColor(student.averageScore),
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      isArabic ? 'المعدل' : 'Average',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isArabic ? 'تقدم الدروس' : 'Lesson Progress',
                      style: AppTextStyles.body2.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${student.completedLessons}/${student.totalLessons}',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: student.completedLessons / student.totalLessons,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                    _getProgressColor(student.completedLessons / student.totalLessons),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Mini Chart
            SizedBox(
              height: 60,
              child: CustomPaint(
                painter: MiniChartPainter(student.progressData),
                size: const Size(double.infinity, 60),
              ),
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  isArabic ? 'رسالة' : 'Message',
                  Icons.message,
                  Colors.blue,
                      () => _sendMessage(student),
                ),
                _buildActionButton(
                  isArabic ? 'التفاصيل' : 'Details',
                  Icons.info,
                  Colors.green,
                      () => _viewDetails(student),
                ),
                _buildActionButton(
                  isArabic ? 'تقرير' : 'Report',
                  Icons.assessment,
                  Colors.orange,
                      () => _generateReport(student),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(StudentStatus status, bool isArabic) {
    String text;
    Color color;

    switch (status) {
      case StudentStatus.excellent:
        text = isArabic ? 'ممتاز' : 'Excellent';
        color = Colors.green;
        break;
      case StudentStatus.active:
        text = isArabic ? 'نشط' : 'Active';
        color = Colors.blue;
        break;
      case StudentStatus.struggling:
        text = isArabic ? 'يحتاج مساعدة' : 'Needs Help';
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: AppTextStyles.body2.copyWith(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 80) return Colors.blue;
    if (score >= 70) return Colors.orange;
    return Colors.red;
  }

  Color _getProgressColor(double progress) {
    if (progress >= 0.9) return Colors.green;
    if (progress >= 0.7) return Colors.blue;
    if (progress >= 0.5) return Colors.orange;
    return Colors.red;
  }

  void _sendMessage(StudentData student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Send message to ${student.name}')),
    );
  }

  void _viewDetails(StudentData student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View details for ${student.name}')),
    );
  }

  void _generateReport(StudentData student) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Generate report for ${student.name}')),
    );
  }
}

// Mini Chart Painter
class MiniChartPainter extends CustomPainter {
  final List<double> data;

  MiniChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final y = size.height - (data[i] / 100) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw points
      canvas.drawCircle(Offset(x, y), 3, paint..style = PaintingStyle.fill);
      paint.style = PaintingStyle.stroke;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Student Data Model
class StudentData {
  final String id;
  final String name;
  final String nameAr;
  final String email;
  final String avatar;
  final int completedLessons;
  final int totalLessons;
  final double averageScore;
  final DateTime lastActive;
  final StudentStatus status;
  final List<double> progressData;

  StudentData({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.email,
    required this.avatar,
    required this.completedLessons,
    required this.totalLessons,
    required this.averageScore,
    required this.lastActive,
    required this.status,
    required this.progressData,
  });
}

enum StudentStatus { excellent, active, struggling }