import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  Completer<GoogleMapController> _controller = Completer();
 // Location location;
  final Set<Marker> _markers = {};

  @override
  void initState() {
   // location = Location();
   // location.onLocationChanged().listen((LocationData currentLocation) {
   //   setState(() {
   //     _markers.add(Marker(markerId: MarkerId(Uuid().v1()),
   //     position: LatLng(currentLocation.latitude, currentLocation.longitude)
  //      ));
 //     });
  //    print(currentLocation.latitude);
 //     print(currentLocation.longitude);
 //   });
    super.initState();
  }
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Maps")),
        body: GoogleMap(
      onMapCreated: _onMapCreated,
      mapType: MapType.normal,
      markers: _markers,
      initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    ));
  }
}
