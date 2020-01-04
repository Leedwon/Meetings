class User {
  final double id;
  final String email;
  final String pseudonym;
  final String password;

  User(
    this.id,
    this.email,
    this.pseudonym,
    this.password,
  );

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        pseudonym = json['pseudonyme'], // typo in api
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'pseudonyme': pseudonym, // typo in api
        'password': password
      };
}
