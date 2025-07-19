class AnimalModel {
  final int animalId;
  final String name;
  final String photo;

  AnimalModel({
    required this.animalId,
    required this.name,
    required this.photo,
  });

  factory AnimalModel.fromMap(Map<String, dynamic> map) {
    return AnimalModel(
      animalId: map['AnimalId'],
      name: map['Name'],
      photo: map['Photo'],
    );
  }
}
