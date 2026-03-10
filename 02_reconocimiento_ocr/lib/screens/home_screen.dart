import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/ocr_service.dart';
import 'result_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/loader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isProcessing = false;

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => isProcessing = true);

      final file = File(result.files.single.path!);
      final text = await OcrService().extractTextFromPdf(file);

      if (!mounted) return; // evita usar BuildContext si se desmontó el widget
      setState(() => isProcessing = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(extractedText: text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OCR PDF')),
      body: Center(
        child: isProcessing
            ? const Loader()
            : CustomButton(
                text: 'Subir PDF',
                icon: Icons.upload_file,
                onPressed: pickPDF,
              ),
      ),
    );
  }
}