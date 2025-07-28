class ReptileModel {
  final int reptileId;
  final String name;
  final String photo;
  final int kingdomId;

  ReptileModel({
    required this.reptileId,
    required this.name,
    required this.photo,
    required this.kingdomId,
  });


  factory ReptileModel.fromJson(Map<String, dynamic> json) {
    return ReptileModel(
      reptileId: json['reptileId'] ?? 0,
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      kingdomId: json['kingdomId'] ?? 0,
    );
  }

  factory ReptileModel.fromMap(Map<String, dynamic> map) {
    return ReptileModel(
      reptileId: map['reptileId'],
      name: map['name'],
      photo: map['photo'],
      kingdomId: map['kingdomId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reptileId': reptileId,
      'name': name,
      'photo': photo,
      'kingdomId': kingdomId,
    };
  }
}
