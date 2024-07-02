import "dart:io";

import "package:http/http.dart" as http;
import "package:path_provider/path_provider.dart";

Future<String> downloadImage(String directory, String url, String fileName) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Lấy thư mục tài liệu của ứng dụng
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/image_source/$fileName';
    final file = File(filePath)..createSync(recursive: true);
    // Lưu hình ảnh vào file
    await file.writeAsBytes(response.bodyBytes,);
    return filePath;
  } else {
    throw Exception('Lỗi tải hình ảnh: $fileName');
  }
}
