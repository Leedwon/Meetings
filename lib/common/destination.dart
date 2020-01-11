import 'package:flutter/material.dart';
import 'package:meetings/icons/meetings_icons.dart';

class Destination {
  const Destination(this.title, this.icon);
  final String title;
  final IconData icon;
}

const PROFILE_DEST_NAME = 'Profile';
const HOME_DEST_NAME = 'Home';
const MEETINGS_DEST_NAME = 'Meetings';

const List<Destination> bottomNavigationDestinations = <Destination>[
  Destination(PROFILE_DEST_NAME, Meetings.user),
  Destination(HOME_DEST_NAME, Meetings.home),
  Destination(MEETINGS_DEST_NAME, Meetings.beer)
];