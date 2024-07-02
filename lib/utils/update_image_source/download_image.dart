import "dart:io";

import "package:http/http.dart" as http;
import "package:path_provider/path_provider.dart";

Future<String> downloadImage(String directory, String url, String fileName) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    try {
      final filePath = '$directory$fileName';
      final file = File(filePath)..createSync(recursive: true);
      // Lưu hình ảnh vào file
      await file.writeAsBytes(
        response.bodyBytes,
      );
      return filePath;
    } catch (e) {
      print(e);
      return "";
    }
  } else {
    throw Exception('Lỗi tải hình ảnh: $fileName');
  }
}
