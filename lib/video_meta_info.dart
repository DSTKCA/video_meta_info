
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;

class VideoMetaInfo {
  static const MethodChannel _channel = MethodChannel('video_meta_info');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<VideoData?> getVideoInfo(String path) async {
    final jsonStr = await _channel.invokeMethod('getVidInfo', {"path": path});
    final jsonMap = json.decode(jsonStr);
    if (!jsonMap["isfileexist"]) {
      developer.log('Video file path is wrong or does not exists. Please recheck file path.',
          name: 'VideoMetaInfo');
    }
    return VideoData.fromJson(jsonMap);
  }
}

class VideoData {
  String? path;

  /// string
  String? title;

  /// string
  String? author;

  /// string
  String? mimetype;

  /// Int
  int? bitrate;

  /// string
  String? date;

  /// string
  String? location;

  /// double
  double? framerate;

  /// int
  int? width;

  /// int
  int? height;

  /// [Android] API level 17, (0,90,180,270)
  /// (0 - LandscapeRight)
  /// (90 - Portrait)
  /// (180 - LandscapeLeft)
  /// (270 - portraitUpsideDown)
  int? orientation;

  /// bytes
  int? filesize;

  /// millisecond
  double? duration;

  VideoData({
    required this.path,
    this.title,
    this.author,
    this.mimetype,
    this.bitrate,
    this.date,
    this.location,
    this.framerate,
    this.width,
    this.height,
    this.orientation,
    this.filesize,
    this.duration,
  });

  VideoData.fromJson(Map<String, dynamic> json) {
    path = (json['path']);
    title = json["isfileexist"] ? (basename(json['path']).split(".")[0]) : null;
    mimetype = (json["mimetype"] == null || json["mimetype"] == "")
        ? null
        : (json["mimetype"]);
    bitrate = int.tryParse('${json['bitrate']}');
    date = (json["date"] == null || json["date"] == '') ? null : json["date"];
    location = (json["location"] == null || json["location"] == '')
        ? null
        : json["location"];
    framerate = double.tryParse("${json["framerate"]}");
    author = (json['author'] == null || json['author'] == '')
        ? null
        : json['author'];
    width = int.tryParse('${json['width']}');
    height = int.tryParse('${json['height']}');
    orientation = int.tryParse(json["orientation"]);
    filesize = json['filesize'];
    duration = json["isfileexist"] ? double.tryParse('${json['duration']}'):null;
  }
}
