class EducationalEntity {
  final int? id;
  final String name;
  final String location;
  final String image;

  EducationalEntity({
    this.id,
    required this.name,
    required this.location,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'image': image,
    };
  }

  factory EducationalEntity.fromMap(Map<String, dynamic> map) {
    return EducationalEntity(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      image: map['image'],
    );
  }
}
