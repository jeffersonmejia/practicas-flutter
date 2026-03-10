import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/image_compressor.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  File? _compressedImage;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _compressedImage = null; // reset compressed
      });
    }
  }

  Future<void> _compressImage() async {
    if (_image == null) return;
    final compressed = await compressImage(_image!);
    setState(() {
      _compressedImage = compressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comprimir Imágenes')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar Imagen'),
            ),
            const SizedBox(height: 20),
            if (_image != null) ...[
              Text('Original:'),
              Image.file(_image!, height: 200),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _compressImage,
                child: const Text('Comprimir Imagen'),
              ),
            ],
            const SizedBox(height: 20),
            if (_compressedImage != null) ...[
              Text('Comprimida:'),
              Image.file(_compressedImage!, height: 200),
            ],
          ],
        ),
      ),
    );
  }
}