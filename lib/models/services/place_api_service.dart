import 'dart:convert';

import 'package:http/http.dart';
import 'package:meetings/utils/network_utils.dart';

import '../place.dart';

class PlaceApiService {
  final Client client;
  final String url = "$BASE_URL/place";

  PlaceApiService(this.client);

  Future<Place> getPlaceById(int id) async {
    final response = await client.get("$url/get/byId?id=$id");
    if (response.statusCode == 200) {
      return Place.fromJson(jsonDecode(response.body));
    } else {
      return Future.error("no place with given id = $id");
    }
  }

  Future<Place> getPlaceByName(String name) async {
    final response = await client.get("$url/get/byName?name=$name");
    if (response.statusCode == 200) {
      return Place.fromJson(jsonDecode(response.body));
    } else {
      return Future.error("no place with given name");
    }
  }

  Future<List<Place>> getPlaceByNameAutoCorrect(String name) async {
    final response = await client.get("$url/get/byNameAutoCorrect?name=$name");
    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson.map<Place>((json) {
        return Place.fromJson(json);
      }).toList();
    } else {
      return Future.error("no place with given name");
    }
  }

  Future<List<Place>> getAllPlaces() async {
    final response = await client.get("$url/get/all");
    if (response.statusCode == 200) {
      List<dynamic> decodedJson = jsonDecode(response.body);
      return decodedJson.map<Place>((json) {
        return Place.fromJson(json);
      }).toList();
    } else {
      return Future.error("no place with given name");
    }
  }


}
