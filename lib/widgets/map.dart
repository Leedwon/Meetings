import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class MapWidget extends StatefulWidget {
  final List<LatLng> markers;

  MapWidget(this.markers);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Marker _mapLatLngToMarker(LatLng latLng) {
    return Marker(markerId: MarkerId(Uuid().toString()), position: latLng);
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition:
            CameraPosition(target: widget.markers[0], zoom: 16.0),
        markers: widget.markers
            .map((latLng) => _mapLatLngToMarker(latLng))
            .toSet()
    );
  }
}
