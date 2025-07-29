class BirdModel {
  final int birdId;
  final String name;
  final String photo;
  final int kingdomId;

  BirdModel({
    required this.birdId,
    required this.name,
    required this.photo,
    required this.kingdomId,
  });


  factory BirdModel.fromJson(Map<String, dynamic> json) {
    return BirdModel(
      birdId: json['birdId'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      kingdomId: json['kingdomId'] ?? 0,
    );
  }


  factory BirdModel.fromMap(Map<String, dynamic> map) {
    return BirdModel(
      birdId: map['birdId'],
      name: map['name'],
      photo: map['photo'],
      kingdomId: map['kingdomId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'birdId': birdId,
      'name': name,
      'photo': photo,
      'kingdomId': kingdomId,
    };
  }
}
