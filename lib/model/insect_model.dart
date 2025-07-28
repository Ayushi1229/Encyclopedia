class InsectModel {
  final int insectId;
  final String name;
  final String photo;
  final int kingdomId;

  InsectModel({
    required this.insectId,
    required this.name,
    required this.photo,
    required this.kingdomId,
  });


  factory InsectModel.fromJson(Map<String, dynamic> json) {
    return InsectModel(
      insectId: json['insectId'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      kingdomId: json['kingdomId'] ?? 0,
    );
  }


  factory InsectModel.fromMap(Map<String, dynamic> map) {
    return InsectModel(
      insectId: map['insectId'],
      name: map['name'],
      photo: map['photo'],
      kingdomId: map['kingdomId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'insectId': insectId,
      'name': name,
      'photo': photo,
      'kingdomId': kingdomId,
    };
  }
}
