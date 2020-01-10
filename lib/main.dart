import 'package:flutter/material.dart';
import 'package:meetings/utils/shared_preferences_utils.dart';
import 'package:meetings/views/logged_in/logged_in.dart';
import 'package:meetings/views/login/login_view.dart';
import 'package:meetings/views/map/map_view.dart';
import 'package:meetings/views/register/regiser_view.dart';
import 'package:meetings/widgets/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _isLoggedIn(),
        builder: (context, snapshot) {
          return MaterialApp(
              onGenerateRoute: (RouteSettings settings) {
                String currentRoute = settings.name;

                var routes = <String, WidgetBuilder>{
                  '/logged_in': (BuildContext context) => LoggedInScreen(),
                  '/login': (BuildContext context) => LoginScreen(),
                  '/register': (BuildContext context) => RegisterScreen(),
                  '/map': (BuildContext context) => MapScreen(),
                  '/': (BuildContext context) =>
                      _getWidgetBasedOnSnapshot(snapshot)
                };
                WidgetBuilder myBuilder = routes[currentRoute];
                return MaterialPageRoute(builder: myBuilder);
              },
              title: 'Meetings',
              theme: ThemeData(
                // is not restarted.
                primarySwatch: Colors.blue,
              ),
              home: _getWidgetBasedOnSnapshot(snapshot));
        });
  }

  Future<bool> _isLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int id = preferences.getInt(USER_ID);
    if (id != null) {
      return true;
    } else {
      return false;
    }
  }

  Widget _getWidgetBasedOnSnapshot(AsyncSnapshot<bool> isLoggedIn) {
    if (!isLoggedIn.hasData) {
      return SplashScreen();
    } else if (isLoggedIn.data) {
      return LoggedInScreen();
    } else {
      return LoginScreen();
    }
  }
}
