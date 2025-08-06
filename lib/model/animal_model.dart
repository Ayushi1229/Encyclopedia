class AnimalModel {
  final int animalId;
  final String name;
  final String photo;
  final int kingdomId;
  final int continentId;
  final int foodId;
  final int typeId;
  final String continentName;
  final String typeName;
  final String foodName;
  final String sound;

  AnimalModel({
    required this.animalId,
    required this.name,
    required this.photo,
    required this.kingdomId,
    required this.continentId,
    required this.foodId,
    required this.typeId,
    required this.continentName,
    required this.foodName,
    required this.typeName,
    required this.sound,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    return AnimalModel(
      animalId: json['animalId'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      kingdomId: json['kingdomId'] ?? 0,
      continentId: json['continentId'] ?? 0,
      foodId: json['foodId'] ?? 0,
      typeId: json['typeId'] ?? 0,
      continentName: json['continentName'] ?? 0,
      foodName: json['foodName'] ?? 0,
      typeName: json['typeName'] ?? 0,
      sound: json['sound'] ?? 0
    );
  }

  factory AnimalModel.fromMap(Map<String, dynamic> map) {
    return AnimalModel(
      animalId: map['animalId'],
      name: map['name'],
      photo: map['photo'],
      kingdomId: map['kingdomId'],
      continentId: map['continentId'],
      foodId: map['foodId'],
      typeId: map['typeId'],
      continentName: map['continentName'],
      typeName: map['typeName'],
      foodName: map['foodName'],
      sound: map['sound'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'animalId': animalId,
      'name': name,
      'photo': photo,
      'kingdomId': kingdomId,
      'continentId':continentId,
      'foodId':foodId,
      'typeId':typeId,
      'continentName' : continentName,
      'typeName' : typeName,
      'foodName' : foodName,
      'sound' : sound
    };
  }

  @override
  String toString() {
    return '''
AnimalModel {
  animalId: $animalId,
  name: $name,
  photo: $photo,
  kingdomId: $kingdomId,
  continentId: $continentId,
  foodId: $foodId,
  typeId: $typeId,
  continentName : $continentName,
  typeName : $typeName,
  foodName : $foodName,
  sound : $sound
}''';
  }

}
