class BirdModel {
  final int birdId;
  final String name;
  final String photo;
  final int kingdomId;
  final int continentId;
  final int foodId;
  final int typeId;
  final String continentName;
  final String typeName;
  final String foodName;

  BirdModel({
    required this.birdId,
    required this.name,
    required this.photo,
    required this.kingdomId,
    required this.continentId,
    required this.foodId,
    required this.typeId,
    required this.continentName,
    required this.foodName,
    required this.typeName
  });


  factory BirdModel.fromJson(Map<String, dynamic> json) {
    return BirdModel(
      birdId: json['birdId'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      kingdomId: json['kingdomId'] ?? 0,
      continentId: json['continentId'] ?? 0,
      foodId: json['foodId'] ?? 0,
      typeId: json['typeId'] ?? 0,
        continentName: json['continentName'] ?? 0,
        foodName: json['foodName'] ?? 0,
        typeName: json['typeName'] ?? 0,

    );
  }


  factory BirdModel.fromMap(Map<String, dynamic> map) {
    return BirdModel(
      birdId: map['birdId'],
      name: map['name'],
      photo: map['photo'],
      kingdomId: map['kingdomId'],
      continentId: map['continentId'],
      foodId: map['foodId'],
      typeId: map['typeId'],
        continentName: map['continentName'],
        typeName: map['typeName'],
        foodName: map['foodName']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'birdId': birdId,
      'name': name,
      'photo': photo,
      'kingdomId': kingdomId,
      'continentId':continentId,
      'foodId':foodId,
      'typeId':typeId,
      'continentName' : continentName,
      'typeName' : typeName,
      'foodName' : foodName
    };
  }

@override
String toString() {
  return '''
BirdModel {
  birdId: $birdId,
  name: $name,
  photo: $photo,
  kingdomId: $kingdomId,
  continentId: $continentId,
  foodId: $foodId,
  typeId: $typeId,
  continentName : $continentName,
  typeName : $typeName,
  foodName : $foodName
}''';
}

}