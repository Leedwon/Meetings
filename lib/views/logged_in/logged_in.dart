import 'package:flutter/material.dart';
import 'package:meetings/common/destination.dart';
import 'package:meetings/views/home/home_view.dart';
import 'package:meetings/views/map/map_view.dart';
import 'package:meetings/views/meetings/meetings_view.dart';
import 'package:meetings/views/profile/profile_view.dart';

class LoggedInScreen extends StatefulWidget {
  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {
  int _currentIndex;

  final ProfileScreen _profileScreen = ProfileScreen();
  final HomeScreen _homeScreen = HomeScreen();
  final MeetingsScreen _meetingsScreen = MeetingsScreen();

  @override
  void initState() {
    super.initState();
    _currentIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: IndexedStack(
              index: _currentIndex,
              children: bottomNavigationDestinations
                  .map<Widget>((Destination destination) {
                switch (destination.title) {
                  case PROFILE_DEST_NAME:
                    {
                      return _profileScreen;
                    }
                  case HOME_DEST_NAME:
                    {
                      return _homeScreen;
                    }
                  default:
                    {
                      return _meetingsScreen;
                    }
                }
              }).toList())),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            //todo: refactor ugly af
            switch(index){
              case 0: {
                _profileScreen.refresh();
                break;
              }
              case 1: {
                break;
              }
              case 2: {
                _meetingsScreen.refresh();
                break;
              }
            }
            _currentIndex = index;
          });
        },
        items: bottomNavigationDestinations.map((Destination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon), title: Text(destination.title));
        }).toList(),
      ),
    );
  }
}
