import 'package:flutter/material.dart';
import 'dart:io';

class ResultScreen extends StatelessWidget {
  final String extractedText;
  final List<File>? extractedImages;

  const ResultScreen({
    super.key,
    required this.extractedText,
    this.extractedImages,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgSoft = Colors.white; // Fondo limpio
    final Color textSoft = const Color(0xFF202124); // Texto principal
    final Color boxBg = const Color(0xFFE6F4EA); // Caja verde suave tipo Google Account
    final Color titleColor = const Color(0xFF196F3D); // Títulos verdes oscuros suaves

    return Scaffold(
      backgroundColor: bgSoft,
      appBar: AppBar(
        title: const Text('Resultados OCR', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: bgSoft,
        foregroundColor: textSoft,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Texto Extraído',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: boxBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                extractedText,
                style: TextStyle(
                  fontSize: 16,
                  color: textSoft,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (extractedImages != null && extractedImages!.isNotEmpty) ...[
              Text(
                'PDF original',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
              ),
              const SizedBox(height: 8),
              ...extractedImages!.map(
                (file) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.file(file),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
