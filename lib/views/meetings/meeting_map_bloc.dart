import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/user.dart';
import 'package:rxdart/rxdart.dart';

import '../base_bloc.dart';

class MeetingMapState {
  final List<LatLng> usersLatLngs;
  final LatLng placeLatLng;

  MeetingMapState(this.usersLatLngs, this.placeLatLng);
}

class MeetingMapBloc extends BaseBloc {
  final int _meetingId;
  final int _placeId;
  final MeetingsApiService _meetingApiService;
  final PlaceApiService _placeApiService;

  final BehaviorSubject<List<User>> _users = BehaviorSubject();

  final BehaviorSubject<LatLng> _placeLatLng = BehaviorSubject();

  Stream<MeetingMapState> get state =>
      CombineLatestStream.combine2(_users.stream, _placeLatLng.stream,
          (List<User> userMarkers, LatLng placeMarker) {
        return MeetingMapState(
            userMarkers
                .map((user) => LatLng(user.latitude, user.longitude))
                .toList(),
            placeMarker);
      });

  void init() {
    _fetchUsersAndPlace();

    Stream.periodic(Duration(seconds: 30), (computation) {
      print("next iteration of MeetingMapBloc user fetching = $computation");
    }).listen((onNext) {
      _meetingApiService.getUsersInMeeting(_meetingId).then((users) {
        print("adding to users sink");
        _users.sink.add(users);
      });
    });
  }

  void _fetchUsersAndPlace() {
    _meetingApiService.getUsersInMeeting(_meetingId).then((users) {
      print("adding to users sink");
      _users.sink.add(users);
    });
    _placeApiService.getPlaceById(_placeId).then((place) {
      print("adding to place sink");
      _placeLatLng.sink.add(LatLng(place.latitude, place.longitude));
    });
  }

  MeetingMapBloc(this._meetingId, this._placeId, this._meetingApiService,
      this._placeApiService);

  @override
  void dispose() {
    _placeLatLng.close();
    _users.close();
  }
}
