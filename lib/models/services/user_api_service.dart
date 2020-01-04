import 'dart:convert';

import 'package:http/http.dart';

import '../user.dart';

class UserApiService {
  final Client client;
  final String url = "http://192.168.0.17:8080/user";

  UserApiService(
    this.client,
  );

  /// @return  userId
  Future<double> login(String email, String password) async {
    final response = await client.get("$url/get/byCredentials?email=$email&password=$password");
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      return Future.error("Invalid email or password");
    }
  }

  /// @return userId
  Future<double> register(String email, String pseudonym, String password) async {
  final response = await client.get("$url/post/createUser?email=$email&pseudonyme=$pseudonym&password=$password");
  if(response.statusCode == 200){
    return double.parse(response.body);
  } else {
    return Future.error("Registration process failed");
  }
  }

  Future<User> getUser(double id) async {
    final response = await client.get("$url/get/byId?id=$id");
    if(response.statusCode == 200){
      return User.fromJson(jsonDecode(response.body));
    } else {
      return Future.error("Couldn't find user with given id");
    }
  }
}
