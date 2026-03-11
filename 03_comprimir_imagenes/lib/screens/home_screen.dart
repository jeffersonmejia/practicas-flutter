import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/image_compressor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  File? _compressedImage;

  int? _originalSize;
  int? _compressedSize;

  final ImagePicker picker = ImagePicker();

  String _formatSize(int bytes) {
    const kb = 1024;
    const mb = 1024 * 1024;

    if (bytes >= mb) {
      return "${(bytes / mb).toStringAsFixed(2)} MB";
    }
    return "${(bytes / kb).toStringAsFixed(2)} KB";
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final size = await file.length();

      setState(() {
        _image = file;
        _originalSize = size;
        _compressedImage = null;
        _compressedSize = null;
      });
    }
  }

  Future<void> _compressImage() async {
    if (_image == null) return;

    final compressed = await compressImage(_image!);
    final size = await compressed.length();

    setState(() {
      _compressedImage = compressed;
      _compressedSize = size;
    });
  }

  Widget _buildImageCard({
    required String title,
    required IconData icon,
    required File image,
    required int size,
  }) {
    return Card(
      elevation: 0,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.blue.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatSize(size),
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                image,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparison() {
    if (_originalSize == null || _compressedSize == null) {
      return const SizedBox();
    }

    final saved = _originalSize! - _compressedSize!;
    final percent = (saved / _originalSize!) * 100;

    return Card(
      elevation: 0,
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.green.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.savings_outlined, color: Colors.green.shade700),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Reducción: ${_formatSize(saved)}  |  ${percent.toStringAsFixed(1)}%",
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Compresión de Imágenes"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilledButton.icon(
              icon: const Icon(Icons.photo_library_outlined),
              label: const Text("Seleccionar imagen"),
              onPressed: _pickImage,
            ),

            const SizedBox(height: 20),

            if (_image != null && _originalSize != null)
              _buildImageCard(
                title: "Imagen original",
                icon: Icons.image_outlined,
                image: _image!,
                size: _originalSize!,
              ),

            const SizedBox(height: 16),

            if (_image != null)
              FilledButton.icon(
                icon: const Icon(Icons.compress_outlined),
                label: const Text("Comprimir imagen"),
                onPressed: _compressImage,
              ),

            const SizedBox(height: 20),

            if (_compressedImage != null && _compressedSize != null)
              _buildImageCard(
                title: "Imagen comprimida",
                icon: Icons.image_aspect_ratio_outlined,
                image: _compressedImage!,
                size: _compressedSize!,
              ),

            const SizedBox(height: 16),

            _buildComparison(),
          ],
        ),
      ),
    );
  }
}