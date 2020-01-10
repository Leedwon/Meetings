import 'dart:async';
import 'package:meetings/models/services/friends_api_service.dart';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:meetings/models/user.dart';
import 'package:meetings/utils/shared_preferences_utils.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_bloc.dart';

class ProfileState {
  final List<User> friends;
  final String pseudonym;
  final String email;
  final String error;
  final bool loading;
  final bool buttonLoading;

  ProfileState({this.friends,
    this.pseudonym,
    this.email,
    this.error,
    this.loading,
    this.buttonLoading});
}

class ProfileBloc extends BaseBloc {
  final UserApiService _userApiService;
  final FriendsApiService _friendsApiService;

  final BehaviorSubject<Optional<ProfileState>> _profileStateSubject =
  BehaviorSubject.seeded(Optional.absent());
  final BehaviorSubject<Optional<String>> _snackbarSubject =
  BehaviorSubject.seeded(Optional.absent());

  Stream<Optional<ProfileState>> get profileState =>
      _profileStateSubject.stream;

  Stream<Optional<String>> get snackbar => _snackbarSubject.stream;

  final _friendNameController = BehaviorSubject<String>();

  ProfileBloc(this._userApiService, this._friendsApiService);

  void changeFriendsEmail(String value) {
    _friendNameController.sink.add(value);
    final ProfileState currentState = _profileStateSubject.value.value;
    _profileStateSubject.sink.add(Optional.of(ProfileState(
        friends: currentState.friends,
        pseudonym: currentState.pseudonym,
        email: currentState.email,
        error: null,
        loading: false,
        buttonLoading: false)));
  }

  void fetchData() async {
    _profileStateSubject.sink.add(Optional.of(ProfileState(loading: true)));

    int id = await getUserId();

    User user = await _userApiService.getUserById(id);
    print("from ProfileBloc got user with psueudonym ${user.pseudonym}");

    _fetchFriendsAndSetState(id, user.pseudonym, user.email);
  }

  void addFriend() async {
    final ProfileState currentState = _profileStateSubject.value.value;
    _profileStateSubject.sink.add(Optional.of(ProfileState(
        friends: currentState.friends,
        pseudonym: currentState.pseudonym,
        email: currentState.email,
        loading: false,
        buttonLoading: true)));

    int id = await getUserId();

    String email = _friendNameController.value;

    await _friendsApiService.addFriend(id, email).then((_) async {
      _fetchFriendsAndSetState(id, currentState.pseudonym, currentState.email);
    }).catchError((error) {
      _profileStateSubject.sink.add(Optional.of(ProfileState(
          friends: currentState.friends,
          pseudonym: currentState.pseudonym,
          email: currentState.email,
          error: error,
          loading: false,
          buttonLoading: false)));
    });
  }

  void removeFriend(String email) async {
    final ProfileState currentState = _profileStateSubject.value.value;


    int id = await getUserId();

    await _friendsApiService.removeFriendship(id, email)
        .then((value) async {
      _fetchFriendsAndSetState(id, currentState.pseudonym, currentState.email);
    }).catchError((error) => _snackbarSubject.sink.add(Optional.of(error)));
  }

  void _fetchFriendsAndSetState(int id, String pseudonym, String email) async {
    await _friendsApiService.getUserFriends(id).then((friends) {
      _profileStateSubject.sink.add(Optional.of(ProfileState(
          friends: friends,
          pseudonym: pseudonym,
          email: email,
          error: null,
          loading: false,
          buttonLoading: false)));
    }).catchError((error) => _snackbarSubject.sink.add(Optional.of(error)));
  }

  @override
  void dispose() {
    _snackbarSubject.close();
    _profileStateSubject.close();
    _friendNameController.close();
  }
}
