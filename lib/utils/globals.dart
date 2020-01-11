import 'package:flutter/material.dart';

MyGlobals myGlobals = new MyGlobals();
class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}