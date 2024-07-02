import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:upload_data/utils/update_data_ai/pick_folder.dart';

Future<void> resize() async {
  final a = await pickFolder((p0) => null);
  if (a != null) {
    for (int i = 0; i < a.length; i++) {
      print("load: ${a[i]}");
      final file = File(a[i]);
      final da = file.lengthSync();
      if (da > 4000000) {
        await testCompressAndGetFile(file, "${a[i].split(".")[0]}copy.png");
      }
    }
  }
}

Future<dynamic> testCompressAndGetFile(File file, String targetPath) async {
  try {
    await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
    );
    print("done: $file");
  } catch (e) {
    print(e);
  }
}
