import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class OcrService {
  static Future<String> extractText(String filePath) async {
    final pdfDocument = await PdfDocument.openFile(filePath);
    final pageCount = pdfDocument.pageCount;
    String allText = '';

    for (int i = 1; i <= pageCount; i++) {
      final page = await pdfDocument.getPage(i);

      final pageImage = await page.render(
        width: page.width.toInt(),
        height: page.height.toInt(),
      );

      // Convierte a ui.Image
      final ui.Image uiImage =
          await pageImage!.createImageIfNotAvailable();

      // Convierte ui.Image a PNG bytes
      final byteData = await uiImage.toByteData(
          format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // Guarda PNG temporal
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/page_$i.png');
      await tempFile.writeAsBytes(pngBytes);

      // Extrae texto OCR
      final pageText = await TesseractOcr.extractText(tempFile.path);
      allText += pageText + '\n';
    }

    return allText;
  }
}