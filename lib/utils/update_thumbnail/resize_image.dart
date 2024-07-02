import 'dart:io';
import 'package:image/image.dart';


Future<String> resizeImage(String inputPath, String outputPath) async {
  Image image = decodeImage(File(inputPath).readAsBytesSync())!;
  Image resized = copyResize(image, width: 480,interpolation: Interpolation.cubic);
  File(outputPath)..createSync(recursive: true)..writeAsBytesSync(encodeJpg(resized,quality: 90),);
  return outputPath;
}
