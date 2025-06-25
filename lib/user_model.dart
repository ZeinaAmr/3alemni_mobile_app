class User {
  int? id;
  String name;
  String email;
  List<double> embedding;

  User({this.id, required this.name, required this.email, required this.embedding});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'embedding': embedding.join(','),
  };

  static User fromMap(Map<String, dynamic> map) => User(
    id: map['id'],
    name: map['name'],
    email: map['email'],
    embedding: map['embedding'].split(',').map((e) => double.parse(e)).toList(),
  );
}
