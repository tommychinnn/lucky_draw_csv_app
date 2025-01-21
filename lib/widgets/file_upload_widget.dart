import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/file_service.dart';

class FileUploadWidget extends StatelessWidget {
  final Function(List<String>) onFileUploaded;

  const FileUploadWidget({
    super.key,
    required this.onFileUploaded,
  });

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = result.files.first;
      final names = await FileService.readCSV(file);
      onFileUploaded(names);
    }
  }

  void _showTextInputDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          '输入名单 Input Names',
          style: TextStyle(
            color: Color(0xFFE31837),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '每行输入一个名字\nEnter one name per line',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(
                maxHeight: 300,
              ),
              child: SingleChildScrollView(
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Example:\nadrian\nandrew\ntommy\nclaire',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消 Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE31837),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final text = textController.text.trim();
              if (text.isNotEmpty) {
                final names = text
                    .split('\n')
                    .map((name) => name.trim())
                    .where((name) => name.isNotEmpty)
                    .toList();
                if (names.isNotEmpty) {
                  onFileUploaded(names);
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('确认 Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: _pickFile,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE31837),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
          icon: const Icon(Icons.upload_file),
          label: const Text(
            '上传名单 Upload CSV',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _showTextInputDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE31837),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
          ),
          icon: const Icon(Icons.paste),
          label: const Text(
            '粘贴名单 Paste Names',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
} 