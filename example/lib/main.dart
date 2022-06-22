import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:video_meta_info/video_meta_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final videoInfo = VideoMetaInfo();

  @override
  void initState() {
    if (Platform.isAndroid) {
      Permission.contacts.request();
    }
    super.initState();
  }

  String info = "";
  String videoFilePath = "";

  getVideoInfo() async {

    /// here file path of video required
    if (Platform.isIOS) {
      videoFilePath =
          "/Users/User/Library/Developer/CoreSimulator/Devices/6A0D4244-1DEB-49C3-9837-C08E19DAED31/data/Media/DCIM/100APPLE/IMG_0011.mp4";
    } else if (Platform.isAndroid) {
      videoFilePath = "storage/emulated/0/Geocam/Videos/4.mp4";
    }

    // var file;
    XFile? file;

    if (Platform.isMacOS) {
      final typeGroup = XTypeGroup(label: 'videos', extensions: ['mov', 'mp4']);
      file = await openFile(acceptedTypeGroups: [typeGroup]);
    } else {

      XFile? f = await ImagePicker().pickVideo(
          source: ImageSource.gallery, maxDuration: const Duration(seconds: 302));

      if (f!=null) {
        file = f;
      }

      // final FilePickerResult? result = await FilePicker.platform.pickFiles(
      //   type: FileType.video,
      // );

      // final PlatformFile? file = result!.files.first;


      // file = result!.files.first; // File(pickedFile!.path);
    }
    if (file == null) {
      return;
    }

    var a = await videoInfo.getVideoInfo(file.path);
    setState(() {
      info =
          "title=> ${a?.title}\npath=> ${a?.path}\nauthor=> ${a?.author}\nmimetype=> ${a?.mimetype}\nbitrate=> ${a?.bitrate}";
      info +=
          "\nheight=> ${a?.height}\nwidth=> ${a?.width}\nfileSize=> ${a?.filesize} Bytes\nduration=> ${a?.duration} milisec";
      info +=
          "\norientation=> ${a?.orientation}\ndate=> ${a?.date}\nframerate=> ${a?.framerate}";
      info += "\nlocation=> ${a?.location}";
    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            label: const Text(
              "Get Info",
              style: TextStyle(color: Colors.black),
            ),
            icon: const Icon(
              Icons.video_call_outlined,
              color: Colors.purple,
            ),
            onPressed: () async => getVideoInfo(),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.purple,
          title: const Text('Video Info'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Center(
            child: Text(
              info,
              style: const TextStyle(fontSize: 21),
            ),
          ),
        ),
      ),
    );
  }
}
