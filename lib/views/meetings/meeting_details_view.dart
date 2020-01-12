import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:meetings/models/user.dart';
import 'package:meetings/widgets/loading.dart';
import 'package:meetings/widgets/spacing_widget.dart';
import 'package:quiver/core.dart';
import 'package:meetings/utils/date_utils.dart';

import 'meeting_details_bloc.dart';
import 'meetings_view.dart';

class MeetingDetailsScreen extends StatefulWidget {
  final int _meetingId;

  MeetingDetailsScreen(this._meetingId);

  @override
  _MeetingDetailsScreenState createState() =>
      _MeetingDetailsScreenState(_meetingId);
}

class _MeetingDetailsScreenState extends State<MeetingDetailsScreen> {
  MeetingDetailsBloc _meetingDetailsBloc;
  final int _meetingId;

  _MeetingDetailsScreenState(this._meetingId);

  @override
  void initState() {
    super.initState();
    Client client = Client();
    _meetingDetailsBloc = MeetingDetailsBloc(
        _meetingId,
        MeetingsApiService(client),
        UserApiService(client),
        PlaceApiService(client));
    _meetingDetailsBloc.fetchMeeting();
    _meetingDetailsBloc.closeScreen.listen((quit) {
      if (quit) {
        Navigator.of(context).pop(REFRESH);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("meeting details"),
        actions: <Widget>[
          StreamBuilder<bool>(
              stream: _meetingDetailsBloc.isHost,
              builder: (context, snapshot) {
                print(snapshot.data);
                if(!snapshot.hasData){
                  return Container();
                }
                return InkWell(
                  onTap: snapshot.data
                      ? _meetingDetailsBloc.remove
                      : _meetingDetailsBloc.quit,
                  child: Icon(
                      snapshot.data ? Icons.delete_forever : Icons.clear,
                      color: Colors.white),
                );
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<Optional<MeetingDetailsState>>(
          stream: _meetingDetailsBloc.state,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.isNotPresent) {
              return LoadingWidget();
            } else {
              MeetingDetailsState state = snapshot.data.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SpacingWidget(
                      bottomSpacing: 16.0,
                      child: Text(
                        state.description,
                        style: TextStyle(fontSize: 24.0),
                      )),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.place,
                        color: Colors.blue,
                      ),
                      Text(state.place != null
                          ? "${state.place.name ?? ""} ${state.place.streetName ?? ""} ${state.place.streetNumber ?? ""} ${state.place.postalCode ?? ""}"
                          : ""),
                    ],
                  ),
                  SpacingWidget(
                    bottomSpacing: 8.0,
                    child: GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, '/meetingMap',
                            arguments: [state.placeId, state.meetingId]),
                        child: Text(
                          "open meeting map with live location updates",
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                  SpacingWidget(
                    bottomSpacing: 8.0,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                        ),
                        Text(state.startingTime.formatDateTime())
                      ],
                    ),
                  ),
                  Builder(builder: (BuildContext context) {
                    if (state.isHost) {
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Text(
                                "add friend to meeting",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextField(
                                    enabled: !state.loadingFriend,
                                    onChanged:
                                        _meetingDetailsBloc.changeFriendEmail,
                                    decoration: InputDecoration(
                                        hintText: "Friend's email",
                                        errorText: state.friendEmailError),
                                  ),
                                ),
                                _getButton(state.loadingFriend),
                              ],
                            ),
                          ]);
                    } else {
                      return Container();
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Text(
                      "users in meeting :",
                      style: TextStyle(
                          fontSize: 20.0, color: Colors.black.withOpacity(0.6)),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: state.users != null ? state.users.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          List<User> users = state.users;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: users[index].id == state.hostId
                                          ? Colors.blue
                                          : Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(users[index]?.pseudonym ?? ""),
                                  Text(users[index].email ?? "")
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _getButton(bool loading) {
    if (loading) {
      return CircularProgressIndicator();
    } else {
      return RawMaterialButton(
        onPressed: () => _meetingDetailsBloc.addUserToMeeting(),
        child: new Icon(
          Icons.add,
          color: Colors.blue,
          size: 25.0,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.white,
        padding: const EdgeInsets.all(15.0),
      );
    }
  }

  @override
  void dispose() {
    _meetingDetailsBloc.dispose();
    super.dispose();
  }
}
