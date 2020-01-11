import 'package:meetings/models/meeting.dart';
import 'package:meetings/models/place.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:meetings/models/user.dart';
import 'package:rxdart/rxdart.dart';

import '../base_bloc.dart';

class MeetingItem {
  final String hostPseudonym;
  final String placeName;
  final String description;
  final DateTime startingTime;

  MeetingItem(
      this.hostPseudonym, this.placeName, this.description, this.startingTime);
}

class MeetingsBloc extends BaseBloc {
  MeetingsApiService _meetingsApiService;
  UserApiService _userApiService;
  PlaceApiService _placeApiService;

  MeetingsBloc(
      this._meetingsApiService, this._userApiService, this._placeApiService);

  final BehaviorSubject<List<MeetingItem>> _meetingsSubject =
      BehaviorSubject.seeded(List<MeetingItem>());

  Stream<List<MeetingItem>> get meetings => _meetingsSubject.stream;

  void fetchMeetings() async {
    int id = await getUserId();
    Future<List<User>> hostsFuture;
    Future<List<Place>> placesFuture;
    Future<List<Meeting>> meetingsFuture =
        _meetingsApiService.getUsersMeetings(id);
    _meetingsApiService.getUsersMeetings(id).then((meetings) {
      hostsFuture = Future.wait(meetings.map((meeting) {
        return _userApiService.getUserById(meeting.hostId);
      }));
      placesFuture = Future.wait(meetings.map((meeting) {
        return _placeApiService.getPlaceById(meeting.placeId);
      }));
      var list = (ZipStream.zip3(
          hostsFuture.asStream(),
          placesFuture.asStream(),
          meetingsFuture.asStream(), (List<User> hosts, List<Place> places, List<Meeting> meetings) {
        List<MeetingItem> items = List();
        for (int i = 0; i < meetings.length; ++i) {
          items.add(MeetingItem(
              hosts[i].pseudonym,
              places[i].name,
              meetings[i].description,
              DateTime.parse(meetings[i].startingTime)));
        }
        return items;
      }));
      list.first.then((items) {
        _meetingsSubject.sink.add(items);
      });
    }).catchError((onError) {
      //todo:: implement
    });
  }

  @override
  void dispose() {
    _meetingsSubject.close();
  }
}
