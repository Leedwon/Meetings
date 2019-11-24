import 'package:uuid/uuid.dart';

class User {
  final Uuid id;
  final String email;
  final String pseudonyme;
  final String password;

  User(
    this.id,
    this.email,
    this.pseudonyme,
    this.password,
  );

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        pseudonyme = json['pseudonyme'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'pseudonyme': pseudonyme,
        'password': password
      };
}
