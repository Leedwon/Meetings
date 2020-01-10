class Meeting {
  final int id;
  final int hostId;
  final int placeId;
  final String description;
  final String startingTime;

  Meeting(this.id, this.hostId, this.placeId, this.description, this.startingTime);

  Meeting.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        hostId = json['hostId'],
        placeId = json['placeId'],
        description = json['description'],
        startingTime = json['startingTime'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'hostId': hostId,
    'placeId': placeId, // typo in api
    'description': description,
    'startingTime': startingTime,
  };

}