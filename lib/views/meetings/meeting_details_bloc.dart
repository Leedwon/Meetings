import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meetings/models/meeting.dart';
import 'package:meetings/models/place.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:meetings/models/user.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meetings/utils/common.dart';

import '../base_bloc.dart';

class MeetingDetailsState {
  final int meetingId;
  final int hostId;
  final int placeId;
  final String description;
  final DateTime startingTime;
  final Place place;
  final List<User> users;
  final bool isHost;
  final String friendEmailError;
  final bool loadingFriend;

  MeetingDetailsState(
      {this.meetingId,
      this.hostId,
      this.placeId,
      this.description,
      this.startingTime,
      this.place,
      this.users,
      this.isHost,
      this.friendEmailError,
      this.loadingFriend});
}

class MeetingDetailsBloc extends BaseBloc {
  final int meetingId;
  final MeetingsApiService _meetingApiService;
  final UserApiService _userApiService;
  final PlaceApiService _placeApiService;

  BehaviorSubject<String> _friendEmail = BehaviorSubject.seeded("");

  BehaviorSubject<Optional<Meeting>> _meeting =
      BehaviorSubject.seeded(Optional.absent());

  BehaviorSubject<List<User>> _users = BehaviorSubject.seeded(List());

  BehaviorSubject<bool> _isHost = BehaviorSubject.seeded(false);

  BehaviorSubject<Optional<String>> _friendEmailError =
      BehaviorSubject.seeded(Optional.absent());

  BehaviorSubject<Optional<Place>> _place =
      BehaviorSubject.seeded(Optional.absent());

  BehaviorSubject<bool> _loadingFriend = BehaviorSubject.seeded(false);

  BehaviorSubject<bool> _closeScreen = BehaviorSubject.seeded(false);

  void changeFriendEmail(String value) {
    _friendEmail.sink.add(value);
    _friendEmailError.sink.add(Optional.absent());
  }

  Stream<bool> get isHost => _isHost.stream;

  Stream<bool> get closeScreen => _closeScreen.stream;

  Stream<Optional<MeetingDetailsState>> get state =>
      CombineLatestStream.combine6(
          _meeting.stream,
          _users.stream,
          _isHost.stream,
          _friendEmailError.stream,
          _place.stream,
          _loadingFriend.stream, (Optional<Meeting> meeting,
              List<User> users,
              bool isHost,
              Optional<String> friendEmailError,
              Optional<Place> latLng,
              bool loadingFriend) {
        if (meeting.isNotPresent) {
          return Optional.absent();
        } else {
          return MeetingDetailsState(
                  meetingId: meeting.value.id,
                  placeId: meeting.value.placeId,
                  description: meeting.value.description,
                  startingTime: DateTime.parse(meeting.value.startingTime),
                  hostId: meeting.value.hostId,
                  users: users,
                  place: latLng.isPresent ? latLng.value : null,
                  isHost: isHost,
                  friendEmailError: friendEmailError.isPresent
                      ? friendEmailError.value
                      : null,
                  loadingFriend: loadingFriend)
              .toOptional();
        }
      });

  void fetchMeeting() async {
    int userId = await getUserId();

    _meetingApiService.getMeetingById(meetingId).then((meeting) {
      _meeting.sink.add(meeting.toOptional());
      _isHost.sink.add(meeting.hostId == userId);
      _placeApiService
          .getPlaceById(meeting.placeId)
          .then((place) => _place.sink.add(place.toOptional()));
    });

    _fetchUsersInMeeting();
  }

  void remove() {
    _meetingApiService.removeMeeting(meetingId).then((value) {
      _closeScreen.sink.add(true);
    });
  }

  void quit() async {
    int userId = await getUserId();
    _meetingApiService.removeUserFromMeeting(userId, meetingId).then((value) {
      _closeScreen.sink.add(true);
    });
  }

  void _fetchUsersInMeeting() {
    _meetingApiService.getUsersInMeeting(meetingId).then((users) {
      _users.sink.add(users);
    });
  }

  void addUserToMeeting() {
    _loadingFriend.sink.add(true);
    _userApiService.getUserByEmail(_friendEmail.value).then((user) {
      _meetingApiService.addUserToMeeting(user.id, meetingId).then((value) {
        _fetchUsersInMeeting();
      }).whenComplete(() => _loadingFriend.sink.add(false));
    }, onError: (error) {
      _loadingFriend.sink.add(false);
      _friendEmailError.sink
          .add("there is no user connected to this email".toOptional());
    });
  }

  MeetingDetailsBloc(this.meetingId, this._meetingApiService,
      this._userApiService, this._placeApiService);

  @override
  void dispose() {
    _closeScreen.close();
    _place.close();
    _friendEmail.close();
    _friendEmailError.close();
    _meeting.close();
    _users.close();
    _isHost.close();
    _loadingFriend.close();
  }
}
