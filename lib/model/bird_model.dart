class BirdModel {
  final int birdId;
  final String name;
  final String? photo;

  BirdModel({
    required this.birdId,
    required this.name,
    this.photo,
  });

  factory BirdModel.fromJson(Map<String, dynamic> json) {
    return BirdModel(
      birdId: json['BirdId'],
      name: json['Name'],
      photo: json['Photo'],
    );
  }
}
