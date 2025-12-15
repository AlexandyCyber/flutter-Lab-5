class User {
  final String name;
  final String email;
  final String phone;

  const User({
    required this.name,
    required this.email,
    required this.phone,
  });

  User copyWith({String? name, String? email, String? phone}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }
}
