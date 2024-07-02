import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upload_data/utils/get_name_of_link.dart';
import 'package:upload_data/utils/upload_data/pick_folder.dart';

import '../../service/getLinkImageByFile.dart';
import '../../service/service.dart';
import '../update_thumbnail/resize_image.dart';

Future<void> uploadDataAI() async {
  Dio dio = Dio();
  final directory = (await getApplicationDocumentsDirectory()).path;
  final directoryThumbnail = "$directory/image_thumbnail/";

  /// chon folder up -> list image.
  List<String>? listPathFileImage = await pickFolder((name) {});

  if (listPathFileImage == null || listPathFileImage.isEmpty) {
    print("loi list path file image");
    return;
  }

  for (int i = 0; i < listPathFileImage.length; i++) {
    final pathImage = listPathFileImage[i];

    try {
      print("handle ($i/${listPathFileImage.length}): $pathImage");

      final fileName = getNameOfLink(listPathFileImage[i]);

      /// get link image.
      final linkImage = await getLinkImageByFile(dio, pathImage, "ai_$fileName");

      /// resizeImage
      final pathThumbnail = await resizeImage(pathImage, "$directoryThumbnail/thumbnail_ai_$fileName");

      /// get link thumbnail image.
      final linkThumb = await getLinkImageByFile(dio, pathThumbnail, "thumbnail_ai_$fileName");

      /// add image to character.
      await addImage(
        linkImage: linkImage,
        nameCharacter: "cute",
        dio: dio,
        linkThumbnail: linkThumb,
        newCharacterId: "AI",
      );
      print("done ---- ($i/${listPathFileImage.length}): $pathImage");
    } catch (e) {
      print("error ---- ($i/${listPathFileImage.length}): $pathImage");

      print(e);
    }
  }
}
