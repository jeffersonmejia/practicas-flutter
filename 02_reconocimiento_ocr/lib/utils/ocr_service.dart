import 'package:flutter_pdf_text/flutter_pdf_text.dart';

class OcrService {
  static Future<String> extractText(String filePath) async {
    try {
      final pdfDoc = await PDFDoc.fromPath(filePath); // esperar el Future
      final text = await pdfDoc.text; // ahora sí accedemos a 'text'
      return text;
    } catch (e) {
      return 'Error al extraer texto del PDF: $e';
    }
  }
}