class Place {
  final int id;
  final String name;
  final String photoUrl;
  final String streetName;
  final int streetNumber;
  final String postalCode;
  final double latitude;
  final double longitude;

  Place(this.id, this.name, this.photoUrl, this.streetName, this.streetNumber,
      this.postalCode, this.latitude, this.longitude);

  Place.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        photoUrl = json['photoUrl'],
        streetName = json['streetName'],
        streetNumber = json['streetNumber'],
        postalCode = json['postalCode'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'photoUrl': photoUrl, // typo in api
    'streetName': streetName,
    'streetNumber': streetNumber,
    'postalCode': postalCode,
    'latitude' : latitude,
    'longitude' : longitude
  };
}