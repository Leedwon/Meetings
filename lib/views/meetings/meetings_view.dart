import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetings/models/meeting.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/widgets/loading.dart';

import 'meetings_bloc.dart';

class MeetingsScreen extends StatefulWidget {
  @override
  _MeetingsScreenState createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends State<MeetingsScreen> {
  MeetingsBloc _meetingBloc;

  @override
  void initState() {
    super.initState();
    _meetingBloc =
        MeetingsBloc(MeetingsApiService(Client())); // todo refactor to use di
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
            final List<Meeting> meetings = snapshot.data;
            return ListView.builder(
              itemCount: meetings.length,
              itemBuilder: (BuildContext context, int index) {
                final Meeting item = meetings[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("${item.description}"),
                    ),
                    Divider(
                      height: 1.0,
                    )
                  ],
                );
              },
            );
          }),
    );
  }

  @override
  void dispose() {
    _meetingBloc.dispose();
    super.dispose();
  }
}
