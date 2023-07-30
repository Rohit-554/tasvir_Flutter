import 'package:tasvir/models/remote/videos/User.dart';
import 'package:tasvir/models/remote/videos/VideoFile.dart';
import 'package:tasvir/models/remote/videos/VideoPicture.dart';

class Video {
  int id;
  int width;
  int height;
  int duration;
  dynamic fullRes;
  List<dynamic> tags;
  String url;
  String image;
  dynamic avgColor;
  User user;
  List<VideoFile> videoFiles;
  List<VideoPicture> videoPictures;

  Video({
    required this.id,
    required this.width,
    required this.height,
    required this.duration,
    this.fullRes,
    required this.tags,
    required this.url,
    required this.image,
    this.avgColor,
    required this.user,
    required this.videoFiles,
    required this.videoPictures,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    width: json["width"],
    height: json["height"],
    duration: json["duration"],
    fullRes: json["full_res"],
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    url: json["url"],
    image: json["image"],
    avgColor: json["avg_color"],
    user: User.fromJson(json["user"]),
    videoFiles: List<VideoFile>.from(json["video_files"].map((x) => VideoFile.fromJson(x))),
    videoPictures: List<VideoPicture>.from(json["video_pictures"].map((x) => VideoPicture.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "width": width,
    "height": height,
    "duration": duration,
    "full_res": fullRes,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "url": url,
    "image": image,
    "avg_color": avgColor,
    "user": user.toJson(),
    "video_files": List<dynamic>.from(videoFiles.map((x) => x.toJson())),
    "video_pictures": List<dynamic>.from(videoPictures.map((x) => x.toJson())),
  };
}