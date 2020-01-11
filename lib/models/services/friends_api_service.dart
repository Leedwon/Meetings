import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:meetings/utils/network_utils.dart';

import '../user.dart';

class FriendsApiService {
  final Client client;
  final String url = "$BASE_URL/friendship";

  FriendsApiService(this.client);

  //todo:: deleting friendship
  Future<bool> removeFriendship(int id, String email) async {
    final response = await client.get("$url/remove/byUserIdAndEmail?id=$id&email=$email");
    if(response.statusCode == 200){
      return true;
    } else {
      return Future.error("couldn't delete friendship");
    }
  }

  Future<List<User>> getUserFriends(int id) async {
    final response = await client.get("$url/get/byUserId?id=$id");
    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson.map<User>((json){
        return User.fromJson(json);
      }).toList();
    } else {
      return Future.error("error occured");
    }
  }

  Future<bool> addFriend(int id, String email) async {
    final response = await client
        .get("$url/post/createFriendshipByIdAndEmail?firstId=$id&email=$email");
    if (response.statusCode == 200) {
      return true;
    } else {
      return Future.error("There is no user connected to this email");
    }
  }
}
