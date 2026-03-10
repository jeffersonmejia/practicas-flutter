import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/ocr_service.dart';
import 'result_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/loader.dart';
import 'dart:io';

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

      try {
        // Extrae texto e imágenes del PDF
        final data = await OcrService.extractTextAndImages(result.files.single.path!);

        if (!mounted) return;
        setState(() => isProcessing = false);

        // Navega a la pantalla de resultados
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              extractedText: data['text'],
              extractedImages: data['images'], // Lista<File> de imágenes
            ),
          ),
        );
      } catch (e) {
        setState(() => isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al procesar el PDF: $e')),
        );
      }
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