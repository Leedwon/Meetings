import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/views/meetings/meeting_map_bloc.dart';
import 'package:meetings/widgets/loading.dart';
import 'package:uuid/uuid.dart';

class MeetingMapScreen extends StatefulWidget {
  final int _placeId;
  final int _meetingId;

  MeetingMapScreen(this._placeId, this._meetingId);

  @override
  _MeetingMapScreenState createState() =>
      _MeetingMapScreenState(_placeId, _meetingId);
}

class _MeetingMapScreenState extends State<MeetingMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  final int _placeId;
  final int _meetingId;
  MeetingMapBloc _bloc;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    Client client = Client();
    _bloc = MeetingMapBloc(_meetingId, _placeId, MeetingsApiService(client),
        PlaceApiService(client));
    _bloc.init();
  }

  _MeetingMapScreenState(this._placeId, this._meetingId);

  Marker _mapLatLngToMarker(LatLng latLng) {
    return Marker(markerId: MarkerId(Uuid().toString()), position: latLng);
  }

  //todo:: filter user's marker
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("meeting map"),
      ),
      body: StreamBuilder<MeetingMapState>(
          stream: _bloc.state,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            } else {
              print("im here");
              Set<Marker> markers = Set();
              markers.addAll(snapshot.data.usersLatLngs
                  .map((it) => _mapLatLngToMarker(it)));
              markers.add(_mapLatLngToMarker(snapshot.data.placeLatLng));
              return GoogleMap(
                onMapCreated: _onMapCreated,
                markers: markers,
                initialCameraPosition: CameraPosition(
                    target: snapshot.data.placeLatLng, zoom: 16.0),
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
