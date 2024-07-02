import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:upload_data/service/getLinkImageByFile.dart';
import 'package:upload_data/utils/update_data_ai/pick_folder.dart';
import 'package:upload_data/utils/update_data_ai/upload_data_ai.dart';
import 'package:upload_data/utils/update_image_source/update_upload.dart';
import 'package:upload_data/utils/upload_data/upload_data.dart';

import 'utils/get_name_of_link.dart';
import 'utils/resize_image.dart';
import 'utils/upload_card/upload_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     showDialog(
            //         context: context,
            //         builder: (context_) => AlertDialog(
            //               content: const Text("Ban chan chan muon update thumbnail? "),
            //               actions: [
            //                 ElevatedButton(
            //                     onPressed: () {
            //                       Navigator.pop(context_);
            //                     },
            //                     child: const Text("CANCEL")),
            //                 ElevatedButton(onPressed: () {}, child: const Text("UPDATE")),
            //               ],
            //             ));
            //     // updateThumbnail();
            //   },
            //   child: const Text("Update Thumbnail"),
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            ElevatedButton(
              onPressed: () {
                uploadData();
              },
              child: const Text("Update Data"),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                uploadCard();
              },
              child: const Text("Update Card"),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                uploadDataAI();
              },
              child: const Text("Update Data AI"),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                testLink();
              },
              child: const Text("test"),
            ),
            ElevatedButton(
              onPressed: () {
                resize();
              },
              child: const Text("Resize"),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> testLink() async {
  Dio dio = Dio();
  String nameCharacter = "";
  final directory = (await getApplicationDocumentsDirectory()).path;

  /// chon folder up -> list image.
  List<String>? listPathFileImage = await pickFolder((name) {
    nameCharacter = name;
  });

  if (listPathFileImage == null || listPathFileImage.isEmpty) {
    print("loi list path file image");

    return;
  }

  for (int i = 0; i < listPathFileImage.length; i++) {
    final pathImage = listPathFileImage[i];

    print("handle (${i + 1}/${listPathFileImage.length}): $pathImage");

    final fileName = getNameOfLink(listPathFileImage[i]);

    /// get link image.
    getLinkImageByFile(dio, pathImage, "test_$fileName").then((value) => {print(value)});
  }
}
