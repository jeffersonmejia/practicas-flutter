import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/ocr_service.dart';
import 'result_screen.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool isProcessing = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() => isProcessing = true);

      try {
        final data = await OcrService.extractTextAndImages(result.files.single.path!);
        if (!mounted) return;
        setState(() => isProcessing = false);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(
              extractedText: data['text'],
              extractedImages: data['images'],
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
    final Color googleGreenSoft = const Color(0xFF34A853).withOpacity(0.15); // verde suave para fondo botón
    final Color googleGreen = const Color(0xFF0F9D58); // verde texto/icono
    final Color whiteBg = Colors.white;

    return Scaffold(
      backgroundColor: whiteBg,
      appBar: AppBar(
        backgroundColor: whiteBg,
        foregroundColor: Colors.black87,
        elevation: 0,
        title: const Text('OCR PDF', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isProcessing
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        color: googleGreen,
                        strokeWidth: 4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Cargando...',
                      style: TextStyle(
                        color: googleGreen,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Material(
                    color: googleGreenSoft,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: pickPDF,
                      splashColor: googleGreen.withOpacity(0.2),
                      highlightColor: googleGreen.withOpacity(0.05),
                      child: SizedBox(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.upload_file_outlined, color: googleGreen),
                            const SizedBox(width: 12),
                            Text(
                              'Subir PDF',
                              style: TextStyle(
                                color: googleGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}