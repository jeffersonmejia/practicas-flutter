import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

Future<File> compressImage(File file, {int quality = 70, int? minWidth, int? minHeight}) async {
  final dir = await getTemporaryDirectory();
  final targetPath = path.join(dir.path, 'compressed_${path.basename(file.path)}');

  final result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: quality,
    minWidth: minWidth ?? 800,
    minHeight: minHeight ?? 600,
    format: CompressFormat.jpeg,
  );

  if (result == null) throw Exception('No se pudo comprimir la imagen');
  return result;
}