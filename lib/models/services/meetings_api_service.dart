import 'dart:convert';

import 'package:http/http.dart';
import 'package:meetings/models/meeting.dart';
import 'package:meetings/utils/network_utils.dart';

class MeetingsApiService {
  final Client client;
  final String url = "$BASE_URL/meeting";

  MeetingsApiService(this.client);

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
}
