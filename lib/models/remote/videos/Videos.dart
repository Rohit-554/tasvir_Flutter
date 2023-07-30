import 'dart:convert';

import 'package:tasvir/models/remote/videos/Video.dart';

Videos videosFromJson(String str) => Videos.fromJson(json.decode(str));

String videosToJson(Videos data) => json.encode(data.toJson());

class Videos {
  int page;
  int perPage;
  List<Video> videos;
  int totalResults;
  String nextPage;
  String url;

  Videos({
    required this.page,
    required this.perPage,
    required this.videos,
    required this.totalResults,
    required this.nextPage,
    required this.url,
  });

  factory Videos.fromJson(Map<String, dynamic> json) => Videos(
    page: json["page"],
    perPage: json["per_page"],
    videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
    totalResults: json["total_results"],
    nextPage: json["next_page"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "per_page": perPage,
    "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
    "total_results": totalResults,
    "next_page": nextPage,
    "url": url,
  };
}
