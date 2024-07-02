import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upload_data/utils/get_name_of_link.dart';
import 'package:upload_data/utils/upload_data/pick_folder.dart';

import '../../service/getLinkImageByFile.dart';
import '../../service/service.dart';
import '../update_thumbnail/resize_image.dart';

Future<void> uploadData() async {
  Dio dio = Dio();

  List<String>? listFolderCharacter = await pickFolder((name) {});
  if (listFolderCharacter == null || listFolderCharacter.isEmpty) {
    print("loi list path folder image");
    return;
  }

  for (int i = 0; i < listFolderCharacter.length; i++) {
    if (listFolderCharacter[i].contains(".DS_Store")) continue;
    String nameCharacter = listFolderCharacter[i].substring(
      listFolderCharacter[i].lastIndexOf("/") + 1,
    );
    final directory = (await getApplicationDocumentsDirectory()).path;
    final directoryThumbnail = "$directory/image_thumbnail/";
    /// chon folder up -> list image.
    List<String>? listPathFileImage =  await fileOfFolder(listFolderCharacter[i]);

    if (listPathFileImage == null || listPathFileImage.isEmpty) {
      print("loi list path file image");
      return;
    }

    ///check name character
    String? idCharacter = await getIdCharacter(dio, nameCharacter);

    for (int i = 0; i < listPathFileImage.length; i++) {
      if (listPathFileImage[i].contains(".DS_Store")) continue;
      final pathImage = listPathFileImage[i];
      try {
        print("handle (${i + 1}/${listPathFileImage.length}): $pathImage");

        final fileName = getNameOfLink(listPathFileImage[i]);

        /// compress image.
        // final pathImageCompress = await compressAndGetFile(pathImage, "$directoryThumbnail/compress_$fileName");
        final pathImageCompress = pathImage;
        /// get link image.
        final linkImage = await getLinkImageByFile(dio, pathImageCompress, "${nameCharacter}_$fileName");

        /// resizeImage
        final pathThumbnail = await resizeImage(pathImage, "$directoryThumbnail/thumbnail_$fileName");

        /// get link thumbnail image.
        final linkThumb = await getLinkImageByFile(dio, pathThumbnail, "thumbnail_${nameCharacter}_$fileName");

        /// add image to character.
        await addImage(
          linkImage: linkImage,
          nameCharacter: nameCharacter,
          dio: dio,
          linkThumbnail: linkThumb,
          newCharacterId: idCharacter ?? "",
        );
        print("done ---- (${i + 1}/${listPathFileImage.length}): $pathImage");
      } catch (e) {
        print("error ---- (${i + 1}/${listPathFileImage.length}): $pathImage");
        print(e);
      }
    }
  }

}
