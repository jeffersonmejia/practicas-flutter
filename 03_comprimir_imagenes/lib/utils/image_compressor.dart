import 'dart:io';
import 'package:image/image.dart' as img;

Future<File> compressImage(File file, {int quality = 70}) async {
  final bytes = await file.readAsBytes();
  final image = img.decodeImage(bytes);
  if (image == null) throw Exception('No se pudo decodificar la imagen');

  final compressed = img.encodeJpg(image, quality: quality);

  final compressedFile = File('${file.parent.path}/compressed_${file.uri.pathSegments.last}');
  await compressedFile.writeAsBytes(compressed);
  return compressedFile;
}