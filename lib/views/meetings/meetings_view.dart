import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetings/utils/date_utils.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:meetings/widgets/loading.dart';

import 'meetings_bloc.dart';

const String MEETING_ADDED = "meeting-added";

class MeetingsScreen extends StatefulWidget {
  //todo:: ugly solution refactor
  _MeetingsScreenState _currentState;

  @override
  _MeetingsScreenState createState() {
    _currentState = _MeetingsScreenState();
    return _currentState;
  }

  void refresh() {
    _currentState.fetchData();
  }
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  MeetingsBloc _meetingBloc;

  @override
  void initState() {
    super.initState();
    final client = Client();
    _meetingBloc = MeetingsBloc(
        MeetingsApiService(client),
        UserApiService(client),
        PlaceApiService(client)); // todo refactor to use di
    _meetingBloc.fetchMeetings();
  }

  void fetchData() {
    _meetingBloc.fetchMeetings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your meetings"),
      ),
      body: StreamBuilder(
          stream: _meetingBloc.meetings,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            final List<MeetingItem> meetings = snapshot.data;
            return ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (BuildContext context, int index) {
                final MeetingItem item = meetings[index];
                return InkWell(
                  onTap: () => {print("tapped")},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("name : ${item.description}"),
                            Text("hosted by ${item.hostPseudonym}"),
                            Text(
                                "starting time : ${item.startingTime.formatDateTime()} "),
                            Text("takes place at ${item.placeName}")
                          ],
                        ),
                      ),
                      Divider(
                        height: 1.0,
                      )
                    ],
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            var result = await Navigator.pushNamed(context, "/addMeeting");
            if (result == MEETING_ADDED) {
              _meetingBloc.fetchMeetings();
            }
          }),
    );
  }

  @override
  void dispose() {
    _meetingBloc.dispose();
    super.dispose();
  }
}
