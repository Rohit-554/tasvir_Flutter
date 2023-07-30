class VideoFile {
  int id;
  Quality quality;
  FileType fileType;
  int width;
  int height;
  double? fps;
  String link;

  VideoFile({
    required this.id,
    required this.quality,
    required this.fileType,
    required this.width,
    required this.height,
    this.fps,
    required this.link,
  });

  factory VideoFile.fromJson(Map<String, dynamic> json) => VideoFile(
    id: json["id"],
    quality: qualityValues.map[json["quality"]]!,
    fileType: fileTypeValues.map[json["file_type"]]!,
    width: json["width"],
    height: json["height"],
    fps: json["fps"]?.toDouble(),
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quality": qualityValues.reverse[quality],
    "file_type": fileTypeValues.reverse[fileType],
    "width": width,
    "height": height,
    "fps": fps,
    "link": link,
  };
}
enum FileType { VIDEO_MP4 }

final fileTypeValues = EnumValues({
  "video/mp4": FileType.VIDEO_MP4
});

enum Quality { HD, SD }

final qualityValues = EnumValues({
  "hd": Quality.HD,
  "sd": Quality.SD
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}