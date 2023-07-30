
import 'dart:convert';
import 'Photos.dart';
CuratedImages curatedImagesFromJson(String str) => CuratedImages.fromJson(json.decode(str));

String curatedImagesToJson(CuratedImages data) => json.encode(data.toJson());

class CuratedImages {
  int page;
  int perPage;
  List<Photo> photos;
  int totalResults;
  String nextPage;

  CuratedImages({
    required this.page,
    required this.perPage,
    required this.photos,
    required this.totalResults,
    required this.nextPage,
  });

  factory CuratedImages.fromJson(Map<String, dynamic> json) => CuratedImages(
    page: json["page"],
    perPage: json["per_page"],
    photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    totalResults: json["total_results"],
    nextPage: json["next_page"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "per_page": perPage,
    "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    "total_results": totalResults,
    "next_page": nextPage,
  };
}