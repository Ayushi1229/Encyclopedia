class AnimalModel {
  final int animalId;
  final String name;
  final String photo;
  final int kingdomId;

  AnimalModel({
    required this.animalId,
    required this.name,
    required this.photo,
    required this.kingdomId,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      animalId: json['animalId'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      kingdomId: json['kingdomId'] ?? 0,
    );
  }

  factory AnimalModel.fromMap(Map<String, dynamic> map) {
    return AnimalModel(
      animalId: map['animalId'],
      name: map['name'],
      photo: map['photo'],
      kingdomId: map['kingdomId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'animalId': animalId,
      'name': name,
      'photo': photo,
      'kingdomId': kingdomId,
    };
  }
}
