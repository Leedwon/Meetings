import 'package:flutter/material.dart';

import 'loading.dart';

//todo make it a proper splashscreen
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: LoadingWidget(), color: Colors.blue,);
  }
}
