import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<List<String>?> pickFolder(Function(String) nameCharacter) async {
  String? selectFolder = await FilePicker.platform.getDirectoryPath();

  if (selectFolder == null) {
    print("Không có folder nào được chọn");
    return null;
  } else {
    final nameCharacter_ = selectFolder.substring(
      selectFolder.lastIndexOf("/") + 1,
    );
    nameCharacter(nameCharacter_);
    List<String> listPathImage = (await Directory(selectFolder).list().toList()).map((e) => e.path).toList();
    for (var element in listPathImage) {
      print(element);
    }
    return listPathImage;
  }
}
