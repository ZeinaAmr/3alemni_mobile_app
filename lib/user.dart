class User {
  final int? id;
  final String email;
  final String password;
  final String role;

  User({
    this.id,
    required this.email,
    required this.password,
    required this.role,
  }) {
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('Invalid email');
    }
    if (password.isEmpty || password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
    if (!['Student', 'Teacher', 'Assistant', 'Admin'].contains(role)) {
      throw ArgumentError('Invalid role');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
    );
  }
}