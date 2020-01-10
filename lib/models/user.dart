class User {
  final int id;
  final String email;
  final String pseudonym;
  final String passwordHash;
  final double latitude;
  final double longitude;

  User(this.id, this.email, this.pseudonym, this.passwordHash, this.latitude,
      this.longitude);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        pseudonym = json['pseudonyme'],
        // typo in api
        passwordHash = json['passwordHash'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'pseudonyme': pseudonym, // typo in api
        'passwordHash': passwordHash,
        'latitude': latitude,
        'longitude': longitude
      };
}
