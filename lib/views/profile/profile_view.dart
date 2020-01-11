import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetings/models/services/friends_api_service.dart';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:meetings/views/profile/profile_bloc.dart';
import 'package:meetings/widgets/loading.dart';
import 'package:meetings/widgets/profile_loaded_screen.dart';
import 'package:quiver/core.dart';

class ProfileScreen extends StatefulWidget {
  //todo:: ugly solution refactor
  _ProfileScreenState _profileScreenState;

  @override
  _ProfileScreenState createState() {
    _profileScreenState = _ProfileScreenState();
    return _profileScreenState;
  }

  void refresh() {
    _profileScreenState.fetchData();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileBloc _profileBloc;

  @override
  void initState() {
    super.initState();
    final client = Client();
    _profileBloc =
        ProfileBloc(UserApiService(client), FriendsApiService(client));
    _profileBloc.fetchData();
  }

  void fetchData() => _profileBloc.fetchData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Profile")),
        body: StreamBuilder<Optional<ProfileState>>(
          stream: _profileBloc.profileState,
          builder: (context, snapshot) {
            var loading = !snapshot.hasData || snapshot.data.isNotPresent || snapshot.data.value.loading;
            if (loading) {
              return LoadingWidget();
            } else {
              final state = snapshot.data.value;
              return ProfileLoadedScreen(state,
                  onFriendNameChanged: _profileBloc.changeFriendsEmail,
                  onAddClick: () => _profileBloc.addFriend(),
                  onFriendSwapped: (email) => _profileBloc.removeFriend(email));
            }
          },
        ));
  }

  @override
  void dispose() {
    _profileBloc.dispose();
    super.dispose();
  }
}
