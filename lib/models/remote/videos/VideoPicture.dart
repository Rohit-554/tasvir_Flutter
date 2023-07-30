
class VideoPicture {
  int id;
  int nr;
  String picture;

  VideoPicture({
    required this.id,
    required this.nr,
    required this.picture,
  });

  factory VideoPicture.fromJson(Map<String, dynamic> json) => VideoPicture(
    id: json["id"],
    nr: json["nr"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nr": nr,
    "picture": picture,
  };
}