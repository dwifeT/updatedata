import 'package:dio/dio.dart';

Future<String> getLinkImageByFile(Dio dio, String filePath, String fileName) async {
  final data = await MultipartFile.fromFile(filePath, filename: fileName);
  FormData formData = FormData.fromMap({
    "file": data,
  });
  Response response = await dio.post("http://gpt.getdata.one/image-uploads/$fileName", data: formData);

  print("$filePath $fileName ${response.data}");
  return response.data;
}
