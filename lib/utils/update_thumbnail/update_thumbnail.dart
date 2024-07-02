import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upload_data/model/image_model.dart';
import 'package:upload_data/utils/update_thumbnail/resize_image.dart';
import 'package:upload_data/service/service.dart';
import 'download_image.dart';
import '../../service/getLinkImageByFile.dart';
import '../get_name_of_link.dart';

Dio dio = Dio();
Future<void> updateThumbnail() async {
  /// getListImage.
  final List<ImageModel>? imageModels = await getListImage(dio);
  if (imageModels == null) {
    return;
  }
  updateDeQuy(imageModels, imageModels.length);
}

Future<void> updateDeQuy(List<ImageModel> imageModel, int lenght) async {
  List<ImageModel> bugItems = [];

  for (int i = 0; i < imageModel.length; i += 5) {
    Future.wait([
      updateThumbnailFu(imageModel[i+1], bugItems, i+1, lenght),
      updateThumbnailFu(imageModel[i+2], bugItems, i+2, lenght),
      updateThumbnailFu(imageModel[i+3], bugItems, i+3, lenght),
      updateThumbnailFu(imageModel[i+4], bugItems, i+4, lenght),
      updateThumbnailFu(imageModel[i+5], bugItems, i+5, lenght),
    ]);
  }

  if (bugItems.isNotEmpty) {
    updateDeQuy(bugItems, lenght);
  }
}

Future updateThumbnailFu(ImageModel imageModel, List bugItems, int index, int lenght) async {
  print("up ${imageModel.linkUrl}  ... $index/$lenght");

  ///init value.
  //item value
  final item = imageModel;

  //name file
  final fileName = getNameOfLink(item.linkUrl ?? "");
  //get direction to save.
  final directory = (await getApplicationDocumentsDirectory()).path;
  final directorySource = "$directory/image_source/";
  final directoryThumbnail = "$directory/image_thumbnail/";

  /// downloadImage.
  final pathSource = await downloadImage(
    directorySource,
    item.linkUrl ?? "",
    fileName,
  ).catchError((onError) {
    bugItems.add(item);
    return "";
  });

  if (pathSource.isEmpty) return;

  /// resizeImage
  final pathThumbnail = await resizeImage(pathSource, "$directoryThumbnail/thumbnail_$fileName");

  /// up thumbnail to server.
  final linkThumbnail = await getLinkImageByFile(dio, pathThumbnail, "thumbnail_$fileName");

  /// update thumbnailData.
  await updateThumbnailById(item.id ?? "", linkThumbnail, dio);

  print("done: ${item.linkUrl}");
}
