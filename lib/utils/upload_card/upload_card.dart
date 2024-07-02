import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upload_data/utils/get_name_of_link.dart';
import 'package:upload_data/utils/upload_data/pick_folder.dart';

import '../../service/getLinkImageByFile.dart';
import '../../service/service.dart';

Future<void> uploadCard() async {
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
    List<String>? listPathFileImage = await fileOfFolder(listFolderCharacter[i]);

    if (listPathFileImage == null || listPathFileImage.isEmpty) {
      print("loi list path file image");
      continue;
    }

    ///check name character
    String? idCharacter = await getIdCharacterChat(dio, nameCharacter);
    if (idCharacter == null) {
      print("Khong tim thay nhan vat");
      continue;
    }

    for (int i = 0; i < listPathFileImage.length; i++) {
      final pathImage = listPathFileImage[i];

      try {
        print("handle (${i + 1}/${listPathFileImage.length}): $pathImage");

        final fileName = getNameOfLink(listPathFileImage[i]);

        /// resizeImage
        final pathImageCompress = await compressAndGetFile(pathImage, "$directoryThumbnail/$fileName");

        if (pathImageCompress == null) {
          continue;
        }

        /// get link thumbnail image.
        final linkImage = await getLinkImageByFile(dio, pathImageCompress, "${nameCharacter}_$fileName");

        /// add image to character.
        await addCard(
          linkImage: linkImage,
          dio: dio,
          characterId: idCharacter,
        );
        print("done ---- (${i + 1}/${listPathFileImage.length}): $pathImage");
      } catch (e) {
        print("error ---- (${i + 1}/${listPathFileImage.length}): $pathImage");

        print(e);
      }
    }
  }
}

Future<String?> compressAndGetFile(String pathSource, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    pathSource,
    targetPath,
    quality: 100,
  );

  return result?.path;
}
