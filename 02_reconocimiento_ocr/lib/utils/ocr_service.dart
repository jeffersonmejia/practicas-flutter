jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 38.76% · 󰤨 22.6 ms
~/practicas/_02_reconocimiento_ocr/lib
$ ls
main.dart  screens  utils  widgets
jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 38.77% · 󰤨 22.6 ms
~/practicas/_02_reconocimiento_ocr/lib
$ cat main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reconocimiento OCR',
      theme: ThemeData(                                     primarySwatch: Colors.blueGrey,                     scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: const HomeScreen(),
    );
  }
}%                                                  jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 38.77% · 󰤨 20.7 ms
~/practicas/_02_reconocimiento_ocr/lib
$ cat screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/ocr_service.dart';
import 'result_screen.dart';
import '../widgets/custom_button.dart';
import '../widgets/loader.dart';

class HomeScreen extends StatefulWidget {             const HomeScreen({super.key});
                                                      @override
  State<HomeScreen> createState() => _HomeScreenState();
}
                                                    class _HomeScreenState extends State<HomeScreen> {    bool isProcessing = false;                                                                              Future<void> pickPDF() async {                        FilePickerResult? result = await FilePicker.platform.pickFiles(                                           type: FileType.custom,
      allowedExtensions: ['pdf'],                       );
                                                        if (result != null && result.files.single.path != null) {
      setState(() => isProcessing = true);                String text = await OCRService.extractText(result.files.single.path!);
      setState(() => isProcessing = false);

      Navigator.push(                                       context,                                            MaterialPageRoute(builder: (_) => ResultScreen(extractedText: text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(                                      appBar: AppBar(title: const Text('OCR PDF')),
      body: Center(                                         child: isProcessing                                     ? const Loader()                                    : CustomButton(                                         text: 'Subir PDF',                                  icon: Icons.upload_file,                            onPressed: pickPDF,
              ),                                          ),
    );
  }
}%                                                  jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 36.38% · 󰤨 20.4 ms
~/practicas/_02_reconocimiento_ocr/lib
$ cat screens/result_screen.dart
import 'package:flutter/material.dart';                                                                 class ResultScreen extends StatelessWidget {
  final String extractedText;
                                                      const ResultScreen({super.key, required this.extractedText});                                                                                               @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Texto Extraído')),
      body: Padding(                                        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(                         child: SelectableText(
            extractedText,                                      style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),                                                ),
    );                                                }                                                 }%                                                  jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 36.12% · 󰤨 24.1 ms                      ~/practicas/_02_reconocimiento_ocr/lib              $ ls
main.dart  screens  utils  widgets                  jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 36.14% · 󰤨 20.8 ms
~/practicas/_02_reconocimiento_ocr/lib
$ cat utils/ocr_service.dart
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:path_provider/path_provider.dart';
                                                    class OcrService {
  /// Convierte un PDF a imágenes y extrae texto OCR
  Future<String> extractTextFromPdf(File file) async {
    final document = await PdfDocument.openFile(file.path);
    final pageCount = document.pageCount;
    String extractedText = '';
                                                        for (int i = 1; i <= pageCount; i++) {
      final page = await document.getPage(i);
      // Renderiza la página a imagen en memoria
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
      );

      // Convierte bytes a archivo temporal PNG           final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/page_$i.png');
      await tempFile.writeAsBytes(pageImage!.bytes);
                                                          // OCR sobre la imagen
      final text = await TesseractOcr.extractText(tempFile.path);                                             extractedText += text + '\n';

      // No hay dispose ni close en pdf_render >= 1.1.0
    }

    return extractedText;
  }
}%                                                  jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 35.95% · 󰤨 23.0 ms                      ~/practicas/_02_reconocimiento_ocr/lib
$ cat widgets/custom_button.dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
                                                      const CustomButton({super.key, required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        backgroundColor: Colors.blueGrey,                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),                               ),
      onPressed: onPressed,                             );
  }
}%                                                  jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 35.83% · 󰤨 27.9 ms
~/practicas/_02_reconocimiento_ocr/lib              $ cat widgets/loader.dart
import 'package:flutter/material.dart';             import 'package:flutter_spinkit/flutter_spinkit.dart';
class Loader extends StatelessWidget {                const Loader({super.key});

  @override                                           Widget build(BuildContext context) {
    return const SpinKitFadingCircle(
      color: Colors.blueGrey,
      size: 60.0,
    );                                                }
}%                                                  jef@debian 🕷 192.168.1.229
󰍛 84.8% · 󰆼 35.76% · 󰤨 20.7 ms                      ~/practicas/_02_reconocimiento_ocr/lib
$