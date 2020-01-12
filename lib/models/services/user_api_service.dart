import 'dart:convert';

import 'package:http/http.dart';
import 'package:meetings/utils/network_utils.dart';

import '../user.dart';

class UserApiService {
  final Client client;
  final String url = "$BASE_URL/user";

  UserApiService(
    this.client,
  );

  /// @return  userId
  Future<int> login(String email, String password) async {
    final response = await client
        .get("$url/get/byCredentials?email=$email&password=$password");
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      return Future.error("Invalid email or password");
    }
  }

  /// @return userId
  Future<int> register(String email, String pseudonym, String password) async {
    final response = await client.get(
        "$url/post/createUser?email=$email&pseudonyme=$pseudonym&password=$password");
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      return Future.error("Registration process failed");
    }
  }

  Future<User> getUserById(int id) async {
    final response = await client.get("$url/get/byId?id=$id");
    if (response.statusCode == 200) {
      print("got user suscessfully");
      return User.fromJson(jsonDecode(response.body));
    } else {
      print("user fetching error");
      return Future.error("Couldn't find user with given id");
    }
  }

  Future<User> getUserByEmail(String email) async {
    final response = await client.get("$url/get/byEmail?email=$email");
    if (response.statusCode == 200) {
      print("got user suscessfully");
      return User.fromJson(jsonDecode(response.body));
    } else {
      print("user fetching error");
      return Future.error("Couldn't find user with given id");
    }
  }

  Future<bool> updateLocalization(int userId, double latitude, double longitude) async {
    final response = await client.get("$url/put/updateLocalization?id=$userId&latitude=$latitude&longitude=$longitude");
    if(response.statusCode == 200){
      return true;
    } else {
      return Future.error("couldn't update localization");
    }
  }
}
