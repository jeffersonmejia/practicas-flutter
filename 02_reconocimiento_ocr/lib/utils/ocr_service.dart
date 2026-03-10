import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  /// Extrae todo el texto de un PDF.
  static Future<String> extractText(String filePath) async {
    final doc = await PdfDocument.openFile(filePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    String allText = '';

    for (int i = 1; i <= doc.pagesCount; i++) {
      final page = await doc.getPage(i);
      final pageImage = await page.render(
        width: page.width.toDouble(),
        height: page.height.toDouble(),
      );

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/page_$i.png');
      await tempFile.writeAsBytes(pageImage!.bytes);

      final recognizedText = await textRecognizer.processImage(
        InputImage.fromFilePath(tempFile.path),
      );

      allText += recognizedText.text + '\n';
      await page.close();
    }

    textRecognizer.close();
    await doc.close();
    return allText;
  }

  /// Extrae imágenes de cada página y las guarda en archivos temporales.
  static Future<List<File>> extractImages(String filePath) async {
    final doc = await PdfDocument.openFile(filePath);
    List<File> images = [];

    for (int i = 1; i <= doc.pagesCount; i++) {
      final page = await doc.getPage(i);
      final pageImage = await page.render(
        width: page.width.toDouble(),
        height: page.height.toDouble(),
      );

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/page_$i.png');
      await tempFile.writeAsBytes(pageImage!.bytes);
      images.add(tempFile);

      await page.close();
    }

    await doc.close();
    return images;
  }

  /// Extrae texto e imágenes de un PDF a la vez.
  static Future<Map<String, dynamic>> extractTextAndImages(String filePath) async {
    final doc = await PdfDocument.openFile(filePath);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    String allText = '';
    List<File> images = [];

    for (int i = 1; i <= doc.pagesCount; i++) {
      final page = await doc.getPage(i);
      final pageImage = await page.render(
        width: page.width.toDouble(),
        height: page.height.toDouble(),
      );

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/page_$i.png');
      await tempFile.writeAsBytes(pageImage!.bytes);
      images.add(tempFile);

      final recognizedText = await textRecognizer.processImage(
        InputImage.fromFilePath(tempFile.path),
      );

      allText += recognizedText.text + '\n';
      await page.close();
    }

    textRecognizer.close();
    await doc.close();

    return {
      'text': allText,
      'images': images,
    };
  }
}