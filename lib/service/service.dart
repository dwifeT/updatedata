import 'package:dio/dio.dart';
import 'package:upload_data/model/image_model.dart';

Future<List<ImageModel>?> getListImage(Dio dio) async {
  try {
    Dio dio = Dio();
    final res = await dio.get("https://gpt.getdata.one/image-characters", queryParameters: {
      "filter": {
        "offset": 0,
        "limit": 10000,
        "skip": 0,
        "order": "price DESC",
        "where": {
          "additionalProp1": {},
        },
        "fields": {
          "id": true,
          "characterId": true,
          "newCharacterId": true,
          "searchTag": true,
          "linkUrl": true,
          "price": true,
          "numberSet": true,
        }
      },
    });
    final listData = (res.data as List<dynamic>);
    return listData.map((e) {
      return ImageModel.fromJson(e);
    }).toList();
  } catch (e) {
    return null;
  }
}

Future<void> updateThumbnailById(String idImage, String linkThumbnail, Dio dio) async {
  try {
    final res = await dio.patch("https://gpt.getdata.one/image-characters/$idImage", data: {
      "thumbnail": linkThumbnail,
    });
  } catch (e) {
    return;
  }
}

Future<void> addImage({
  required String linkThumbnail,
  required Dio dio,
  required String newCharacterId,
  required String linkImage,
  required String nameCharacter,
}) async {
  try {
    final data = {
      "characterId": "system",
      "newCharacterId": newCharacterId,
      "searchTag": [nameCharacter],
      "linkUrl": linkImage,
      "numberSet": 0,
      "thumbnail": linkThumbnail
    };
    print(data);
    final res = await dio.post("https://gpt.getdata.one/image-characters", data: data);
  } catch (e) {
    return;
  }
}

Future<void> addCard({
  required String linkImage,
  required Dio dio,
  required String characterId,
}) async {
  try {
    final data = {
      "characterId": characterId,
      "searchTag": [],
      "linkUrl": linkImage,
      "numberSet": 0,
      "thumbnail": linkImage,
    };
    print(data);
    final res = await dio.post("https://gpt.getdata.one/image-characters", data: data);
  } catch (e) {
    print("lỗi $e");
    return;
  }
}

Future<String?> getIdCharacter(Dio dio, String nameCharacter) async {
  try {
    final res = await dio.get("https://gpt.getdata.one/new-characters-tot-up", queryParameters: {
      "filter": {
        "offset": 0,
        "limit": 1000,
        "skip": 0,
        "order": "string",
        "where": {"additionalProp1": {}, "name": nameCharacter},
        "fields": {"id": true, "filmId": true, "name": true}
      },
    });
    final data = (res.data as List<dynamic>);
    if (data.isEmpty) {
      return await addNewCharacter(dio, nameCharacter);
    } else {
      return data[0]["id"];
    }
  } catch (e) {
    return null;
  }
}

Future<String?> addNewCharacter(Dio dio, String nameCharacter) async {
  try {
    final data = {"filmId": "string", "name": nameCharacter, "additionalProp1": {}};
    final res = await dio.post("https://gpt.getdata.one/new-characters", data: data);
    final data_ = (res.data);
    return data_["id"];
  } catch (e) {
    return null;
  }
}

Future<String?> getIdCharacterChat(Dio dio, String nameCharacter) async {
  try {
    final res = await dio.get("https://gpt.getdata.one/charactersc-all", queryParameters: {
      "filter": {
        "offset": 0,
        "limit": 1000,
        "skip": 0,
        "order": "string",
        "where": {
          "additionalProp1": {},
          "name": nameCharacter,
          "isPublic": true,
        },
        "fields": {
          "characterId": true,
          "name": true,
          "linkURL": true,
          "prompt": true,
          "hello": true,
          "intro": true,
          "connectors": true,
          "followers": true,
          "uid": true,
          "idVoice": true,
          "voiceName": true,
          "isPublic": true
        }
      },
    });
    print(res);
    final data = (res.data as List<dynamic>);
    if (data.isEmpty) {
      return null;
    } else {
      return data[0]["characterId"];
    }
  } catch (e) {
    return null;
  }
}
