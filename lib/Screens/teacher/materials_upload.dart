import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../providers/language_provider.dart';
import '../../utils/colors.dart';
import '../../utils/text_styles.dart';
import '../../widgets/custom_button.dart';

class MaterialsUpload extends StatefulWidget {
  const MaterialsUpload({Key? key}) : super(key: key);

  @override
  State<MaterialsUpload> createState() => _MaterialsUploadState();
}

class _MaterialsUploadState extends State<MaterialsUpload> {
  final List<MaterialItem> _materials = [
    MaterialItem(
      id: '1',
      title: 'Mathematics Chapter 1',
      titleAr: 'الرياضيات الفصل الأول',
      description: 'Introduction to algebra and basic operations',
      descriptionAr: 'مقدمة في الجبر والعمليات الأساسية',
      type: MaterialType.pdf,
      size: '2.5 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 2)),
      downloadCount: 45,
    ),
    MaterialItem(
      id: '2',
      title: 'Geometry Video Tutorial',
      titleAr: 'فيديو تعليمي للهندسة',
      description: 'Visual explanation of geometric shapes',
      descriptionAr: 'شرح مرئي للأشكال الهندسية',
      type: MaterialType.video,
      size: '125 MB',
      uploadDate: DateTime.now().subtract(const Duration(days: 1)),
      downloadCount: 78,
    ),
    MaterialItem(
      id: '3',
      title: 'Practice Worksheet',
      titleAr: 'ورقة عمل تدريبية',
      description: 'Exercises for chapter 1 and 2',
      descriptionAr: 'تمارين للفصل الأول والثاني',
      type: MaterialType.document,
      size: '1.2 MB',
      uploadDate: DateTime.now().subtract(const Duration(hours: 5)),
      downloadCount: 32,
    ),
  ];

  String _selectedFilter = 'all';

  List<MaterialItem> get _filteredMaterials {
    if (_selectedFilter == 'all') return _materials;

    final type = MaterialType.values.firstWhere(
          (t) => t.toString().split('.').last == _selectedFilter,
    );
    return _materials.where((material) => material.type == type).toList();
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
          isArabic ? 'رفع المواد التعليمية' : 'Upload Materials',
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
                      isArabic ? 'إجمالي المواد' : 'Total Materials',
                      _materials.length.toString(),
                      Icons.folder,
                    ),
                    _buildStatItem(
                      isArabic ? 'التحميلات' : 'Downloads',
                      _materials.fold<int>(0, (sum, item) => sum + item.downloadCount).toString(),
                      Icons.download,
                    ),
                    _buildStatItem(
                      isArabic ? 'الحجم الكلي' : 'Total Size',
                      '${_calculateTotalSize().toStringAsFixed(1)} MB',
                      Icons.storage,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Upload Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButton(
              text: isArabic ? 'رفع مادة جديدة' : 'Upload New Material',
              onPressed: () => _showUploadDialog(context, isArabic),
              height: 50,
              width: double.infinity,
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
                  _buildFilterChip('pdf', isArabic ? 'PDF' : 'PDF', isArabic),
                  _buildFilterChip('video', isArabic ? 'فيديو' : 'Video', isArabic),
                  _buildFilterChip('document', isArabic ? 'مستند' : 'Document', isArabic),
                  _buildFilterChip('image', isArabic ? 'صورة' : 'Image', isArabic),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Materials List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredMaterials.length,
              itemBuilder: (context, index) {
                final material = _filteredMaterials[index];
                return _buildMaterialCard(material, isArabic);
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
            fontSize: 18,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body2.copyWith(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildMaterialCard(MaterialItem material, bool isArabic) {
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
              children: [
                // File Icon
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getTypeColor(material.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getTypeIcon(material.type),
                    color: _getTypeColor(material.type),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),

                // Material Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArabic ? material.titleAr : material.title,
                        style: AppTextStyles.heading3.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isArabic ? material.descriptionAr : material.description,
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Material Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.file_present, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      material.size,
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.download, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${material.downloadCount} ${isArabic ? 'تحميل' : 'downloads'}',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatDate(material.uploadDate, isArabic),
                  style: AppTextStyles.body2.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  isArabic ? 'مشاهدة' : 'View',
                  Icons.visibility,
                  Colors.blue,
                      () => _viewMaterial(material),
                ),
                _buildActionButton(
                  isArabic ? 'تحرير' : 'Edit',
                  Icons.edit,
                  Colors.green,
                      () => _editMaterial(material),
                ),
                _buildActionButton(
                  isArabic ? 'مشاركة' : 'Share',
                  Icons.share,
                  Colors.orange,
                      () => _shareMaterial(material),
                ),
                _buildActionButton(
                  isArabic ? 'حذف' : 'Delete',
                  Icons.delete,
                  Colors.red,
                      () => _deleteMaterial(material.id),
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
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 14),
          label: Text(text, style: const TextStyle(fontSize: 12)),
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

  void _showUploadDialog(BuildContext context, bool isArabic) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    MaterialType selectedType = MaterialType.pdf;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(
            isArabic ? 'رفع مادة جديدة' : 'Upload New Material',
            style: AppTextStyles.heading3,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'عنوان المادة' : 'Material Title',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'وصف المادة' : 'Description',
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<MaterialType>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: isArabic ? 'نوع المادة' : 'Material Type',
                    border: const OutlineInputBorder(),
                  ),
                  items: MaterialType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getTypeName(type, isArabic)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // File picker would be implemented here
                  },
                  icon: const Icon(Icons.upload_file),
                  label: Text(isArabic ? 'اختيار ملف' : 'Choose File'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 45),
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
                  _uploadMaterial(
                    titleController.text,
                    descriptionController.text,
                    selectedType,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(isArabic ? 'رفع' : 'Upload'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTypeIcon(MaterialType type) {
    switch (type) {
      case MaterialType.pdf:
        return Icons.picture_as_pdf;
      case MaterialType.video:
        return Icons.video_file;
      case MaterialType.document:
        return Icons.description;
      case MaterialType.image:
        return Icons.image;
    }
  }

  Color _getTypeColor(MaterialType type) {
    switch (type) {
      case MaterialType.pdf:
        return Colors.red;
      case MaterialType.video:
        return Colors.blue;
      case MaterialType.document:
        return Colors.green;
      case MaterialType.image:
        return Colors.purple;
    }
  }

  String _getTypeName(MaterialType type, bool isArabic) {
    switch (type) {
      case MaterialType.pdf:
        return 'PDF';
      case MaterialType.video:
        return isArabic ? 'فيديو' : 'Video';
      case MaterialType.document:
        return isArabic ? 'مستند' : 'Document';
      case MaterialType.image:
        return isArabic ? 'صورة' : 'Image';
    }
  }

  String _formatDate(DateTime date, bool isArabic) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return isArabic ? '${difference.inDays} أيام' : '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return isArabic ? '${difference.inHours} ساعات' : '${difference.inHours}h ago';
    } else {
      return isArabic ? '${difference.inMinutes} دقائق' : '${difference.inMinutes}m ago';
    }
  }

  double _calculateTotalSize() {
    // Simple calculation - in real app, you'd parse the size strings properly
    return _materials.length * 45.6; // Average size
  }

  void _uploadMaterial(String title, String description, MaterialType type) {
    setState(() {
      _materials.insert(0, MaterialItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        titleAr: title,
        description: description,
        descriptionAr: description,
        type: type,
        size: '${(DateTime.now().millisecondsSinceEpoch % 100) / 10}MB',
        uploadDate: DateTime.now(),
        downloadCount: 0,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Material uploaded successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _viewMaterial(MaterialItem material) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('View material: ${material.title}')),
    );
  }

  void _editMaterial(MaterialItem material) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit material: ${material.title}')),
    );
  }

  void _shareMaterial(MaterialItem material) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share material: ${material.title}')),
    );
  }

  void _deleteMaterial(String materialId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Material'),
        content: const Text('Are you sure you want to delete this material?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _materials.removeWhere((material) => material.id == materialId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Material deleted successfully!'),
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

// Material Item Model
class MaterialItem {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final MaterialType type;
  final String size;
  final DateTime uploadDate;
  final int downloadCount;

  MaterialItem({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.type,
    required this.size,
    required this.uploadDate,
    required this.downloadCount,
  });
}

enum MaterialType { pdf, video, document, image }