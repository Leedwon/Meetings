import 'dart:convert';

import 'package:http/http.dart';
import 'package:meetings/models/meeting.dart';
import 'package:meetings/utils/network_utils.dart';

import '../user.dart';

class MeetingsApiService {
  final Client client;
  final String url = "$BASE_URL/meeting";

  MeetingsApiService(this.client);

  Future<Meeting> getMeetingById(int meetingId) async {
    final response = await client.get("$url/get/byid/?id=$meetingId");
    if (response.statusCode == 200) {
        return Meeting.fromJson(jsonDecode(response.body));
      } else {
      return Future.error("error while fetching meeting with id = $meetingId");
    }
  }

  Future<List<User>> getUsersInMeeting(int meetingId) async {
    final response = await client.get("$url/get/users/?id=$meetingId");
    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson.map<User>((json) {
        return User.fromJson(json);
      }).toList();
    } else {
      return Future.error("error while fetching meeting with id = $meetingId");
    }
  }

  Future<List<Meeting>> getUsersMeetings(int userId) async {
    final response = await client.get("$url/get/meetings/?id=$userId");
    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson.map<Meeting>((json) {
        return Meeting.fromJson(json);
      }).toList();
    } else {
      return Future.error("error while getting user meetings");
    }
  }

  Future<bool> createMeeting(
      int hostId, String startingTime, int placeId, String name) async {
    final response = await client.get(
        "$url/post/createMeeting?hostid=$hostId&placeid=$placeId&description=$name&startingtime=$startingTime");
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error("couldn't create meeting");
    }
  }

  Future<bool> addUserToMeeting(int userId, int meetingId) async {
    final response = await client.get("$url/post/join?userId=$userId&meetingId=$meetingId");
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error("couldn't add user to meeting");
    }
  }

  Future<bool> removeMeeting(int meetingId) async {
    final response = await client.get("$url/remove/byId?id=$meetingId");
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error("couldn't remove meeting");
    }
  }

  Future<bool> removeUserFromMeeting(int userId, int meetingId) async {
    final response = await client.get("$url/remove/byUserAndMeetingId?userId=$userId&meetingId=$meetingId");
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error("couldn't remove user from meeting");
    }
  }
}
