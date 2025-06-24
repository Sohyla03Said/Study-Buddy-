import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        children: [
          // Chart Area
          Expanded(
            flex: 3,
            child: CustomPaint(
              painter: BarChartPainter(),
              size: const Size(double.infinity, 200),
            ),
          ),
          const SizedBox(width: 20),
          // Legend
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem('Lessons', Colors.blue, '65%'),
                const SizedBox(height: 12),
                _buildLegendItem('Quizzes', Colors.green, '78%'),
                const SizedBox(height: 12),
                _buildLegendItem('Materials', Colors.orange, '45%'),
                const SizedBox(height: 12),
                _buildLegendItem('Assessment', Colors.purple, '90%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, String percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.body2.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                percentage,
                style: AppTextStyles.body2.copyWith(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BarChartPainter extends CustomPainter {
  // Hardcoded data for demonstration
  final List<double> data = [0.65, 0.78, 0.45, 0.90, 0.55, 0.72, 0.38];
  final List<Color> colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.pink,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final barWidth = size.width / (data.length * 2);
    final maxHeight = size.height - 40; // Reserve space for baseline

    for (int i = 0; i < data.length; i++) {
      final barHeight = data[i] * maxHeight;
      final x = i * barWidth * 2 + barWidth * 0.5;
      final y = size.height - barHeight - 20;

      // Draw bar
      paint.color = colors[i % colors.length];
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);

      // Optional: Draw data points (commented out for simplicity)
      // canvas.drawCircle(Offset(x + barWidth / 2, y), 3, paint..style = PaintingStyle.fill);
    }

    // Draw baseline
    paint
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(0, size.height - 20),
      Offset(size.width, size.height - 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Return true if data or colors change in the future (currently static)
    return oldDelegate != this;
  }
}