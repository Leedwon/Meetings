import 'package:flutter/material.dart';
import 'package:meetings/utils/shared_preferences_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseBloc {

  @protected
  Future<int> getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int id = preferences.getInt(USER_ID);
    print("reading user id = $id");
    return id;
  }

  @protected
   setUserId(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(USER_ID, id);
    print("writing user id = $id");
  }

  void dispose();
}