import 'package:meetings/models/meeting.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:rxdart/rxdart.dart';

import '../base_bloc.dart';

class MeetingsBloc extends BaseBloc{
  final MeetingsApiService _meetingsApiService;

  MeetingsBloc(this._meetingsApiService);

  final BehaviorSubject<List<Meeting>> _meetingsSubject = BehaviorSubject.seeded(List<Meeting>());

  Stream<List<Meeting>> get meetings => _meetingsSubject.stream;

  void fetchMeetings() async {
    int id = await getUserId();
    _meetingsApiService.getUsersMeetings(id)
    .then((meetings) => _meetingsSubject.sink.add(meetings))
    .catchError((onError) {
      //todo:: implement
    });
  }

  @override
  void dispose(){
    _meetingsSubject.close();
  }
}