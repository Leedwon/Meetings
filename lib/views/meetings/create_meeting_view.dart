import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetings/icons/meetings_icons.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/rating_api_service.dart';
import 'package:meetings/views/meetings/meetings_view.dart';
import 'package:meetings/widgets/date_picker.dart';
import 'package:meetings/widgets/place_rating.dart';
import 'package:meetings/widgets/spacing_widget.dart';

import 'create_meeting_bloc.dart';

class CreateMeetingScreen extends StatefulWidget {

  @override
  _CreateMeetingScreenState createState() => _CreateMeetingScreenState();
}

class _CreateMeetingScreenState extends State<CreateMeetingScreen> {
  CreateMeetingBloc _createMeetingBloc;

  @override
  void initState() {
    super.initState();
    final Client client = Client();
    _createMeetingBloc = CreateMeetingBloc(MeetingsApiService(client),
        PlaceApiService(client), RatingApiService(client));
    _createMeetingBloc.subscribeToSearchQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create meeting"),
        ),
        body: Builder(builder: (BuildContext context) {
          _createMeetingBloc.snackbar.listen((element) {
            if (element.isPresent) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(element.value),
                duration: const Duration(seconds: 3),
              ));
              _createMeetingBloc.errorHandled();
            }
          });
          _createMeetingBloc.meetingAdded.listen((added) {
            if (added.isPresent) {
              Navigator.of(context).pop(REFRESH);
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Meeting created"),
                duration: const Duration(seconds: 3),
              ));
            }
          });
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SpacingWidget(
                  bottomSpacing: 32.0,
                  child: TextField(
                      onChanged: (text) =>
                          _createMeetingBloc.onMeetingsNameChanged(text),
                      decoration: InputDecoration(hintText: "Meeting's name")),
                ),
                SpacingWidget(
                    bottomSpacing: 32.0,
                    child: StreamBuilder<DateTime>(
                        stream: _createMeetingBloc.dateTime,
                        builder: (context, snapshot) {
                          return DatePickerWidget(
                              snapshot.data,
                              (date) =>
                                  _createMeetingBloc.onDateTimeChanged(date));
                        })),
                SpacingWidget(
                  bottomSpacing: 8.0,
                  child: TextField(
                    onChanged: (text) =>
                        _createMeetingBloc.changeSearchQuery(text),
                    decoration: InputDecoration(
                        hintText: "Search for meeting places",
                        suffixIcon: Icon(Meetings.search),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)))),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<PlaceRatingItem>>(
                      stream: _createMeetingBloc.places,
                      // ignore: missing_return
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<PlaceRatingItem> items = snapshot.data;
                          return ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SpacingWidget(
                                  bottomSpacing: 8.0,
                                  child: PlaceRatingWidget(
                                      items[index],
                                      (item) => _createMeetingBloc
                                          .onPlaceChosen(item)),
                                );
                              });
                        }
                      }),
                ),
                Expanded(
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          width: double.infinity,
                          child: RaisedButton(
                              onPressed: () => _createMeetingBloc.addMeeting(),
                              color: Colors.blue,
                              child: Text('Add meeting')))),
                )
              ],
            ),
          );
        }));
  }

  @override
  void dispose() {
    _createMeetingBloc.dispose();
    super.dispose();
  }
}
