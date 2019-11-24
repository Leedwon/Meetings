import 'package:flutter/material.dart';
import 'package:meetings/views/login/login_view.dart';
import 'package:meetings/views/map/map_view.dart';
import 'package:meetings/views/register/regiser_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings){
        String currentRoute = settings.name;

        var routes = <String, WidgetBuilder> {
          '/login': (BuildContext context) => LoginScreen(),
          '/register' : (BuildContext context) => RegisterScreen(),
          '/map' : (BuildContext context) => MapScreen(),
          '/' : (BuildContext context) => LoginScreen() //TODO:: add check if user is registered
        };
        WidgetBuilder myBuilder = routes[currentRoute];
        return MaterialPageRoute(builder : myBuilder);
      },
      title: 'Meetings',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
