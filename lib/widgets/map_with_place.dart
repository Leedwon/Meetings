import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map.dart';

class MapWithPlace extends StatelessWidget {
  final LatLng position;

  MapWithPlace(this.position);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: MapWidget([position]),
    );
  }
}
