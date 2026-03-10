import 'dart:io';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:path_provider/path_provider.dart';

class OcrService {
  static Future<String> extractText(String filePath) async {
    final file = File(filePath);
    final document = await PdfDocument.openFile(file.path);
    final pageCount = document.pageCount;
    String extractedText = '';

    for (int i = 1; i <= pageCount; i++) {
      final page = await document.getPage(i);

      // Renderiza la página a bytes
      final pageBytes = await page.render(
        width: page.width.toInt(),
        height: page.height.toInt(),
      ).then((image) => image!.bytes);

      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/page_$i.png');
      await tempFile.writeAsBytes(pageBytes);

      final text = await TesseractOcr.extractText(tempFile.path);
      extractedText += text + '\n';
    }

    return extractedText;
  }
}