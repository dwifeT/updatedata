import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upload_data/model/image_model.dart';
import 'package:upload_data/service/service.dart';
import 'package:upload_data/utils/update_data_ai/pick_folder.dart';
import 'download_image.dart';
import '../get_name_of_link.dart';

Dio dio = Dio();
Future<void> updateImageSource() async {
  /// getListFolder.
  final List<String>? imageModels = await pickFolder((_) => {});
  if (imageModels == null) {
    return;
  }
  update(imageModels, imageModels.length);
}

Future<void> update(List<String> imageModel, int lenght) async {
  for (int i = 0; i < imageModel.length; i += 1) {
    await updateThumbnailFu(imageModel[i], i, lenght);
  }
}

Future updateThumbnailFu(String imagePathSource, int index, int lenght) async {
  print("up $imagePathSource  ... $index/$lenght");

  ///init value.
  //item value
  final item = imagePathSource;

  //name file
  final fileName = getNameOfLink(item);
  //get direction to save.
  const directoryResize = "/Volumes/Macintosh HD/Users/anh/Downloads/image_resize/";

  /// resizeImage"
  final pathResize = await testCompressAndGetFile(File(imagePathSource), "1_$imagePathSource");
  if (pathResize != null) {
    print(pathResize);
  }
  print(fileName);
  //
  // /// re up to server.
  // await getLinkImageByFile(dio, pathResize, fileName);

  print("done: $item");
}

Future<dynamic> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 90,
    format: CompressFormat.png,
  );
}
