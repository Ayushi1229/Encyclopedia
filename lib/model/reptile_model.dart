class ReptileModel {
  final int reptileId;
  final String name;
  final String photo;
  final int kingdomId;
  final int continentId;
  final int foodId;
  final int typeId;
  final String continentName;
  final String typeName;
  final String foodName;

  ReptileModel({
    required this.reptileId,
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


  factory ReptileModel.fromJson(Map<String, dynamic> json) {
    return ReptileModel(
      reptileId: json['reptileId'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      kingdomId: json['kingdomId'] ?? 0,
      continentId: json['continentId'] ?? 0,
      foodId: json['foodId'] ?? 0,
      typeId: json['typeId'] ?? 0,
        continentName: json['continentName'] ?? 0,
        foodName: json['foodName'] ?? 0,
        typeName: json['typeName'] ?? 0
    );
  }

  factory ReptileModel.fromMap(Map<String, dynamic> map) {
    return ReptileModel(
      reptileId: map['reptileId'],
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
      'reptileId': reptileId,
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
ReptileModel {
  reptileId: $reptileId,
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
