import 'package:meetings/models/place.dart';
import 'package:meetings/models/services/meetings_api_service.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/rating_api_service.dart';
import 'package:meetings/widgets/place_rating.dart';
import 'package:quiver/core.dart';
import 'package:meetings/utils/common.dart';

import '../base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class CreateMeetingBloc extends BaseBloc {
  final MeetingsApiService _meetingsApiService;
  final PlaceApiService _placeApiService;
  final RatingApiService _ratingApiService;

  CreateMeetingBloc(
      this._meetingsApiService, this._placeApiService, this._ratingApiService);

  final BehaviorSubject<String> _meetingsName = BehaviorSubject.seeded("");

  final BehaviorSubject<String> _searchQuerySubject = BehaviorSubject();

  final BehaviorSubject<List<PlaceRatingItem>> _placesSubject =
      BehaviorSubject.seeded(List());

  final BehaviorSubject<DateTime> _dateSubject = BehaviorSubject.seeded(null);

  final BehaviorSubject<Optional<String>> _snackbarSubject =
      BehaviorSubject.seeded(Optional.absent());

  final BehaviorSubject<Optional<bool>> _meetingAdded =
      BehaviorSubject.seeded(Optional.absent());

  Stream<Optional<bool>> get meetingAdded => _meetingAdded.stream;

  Stream<Optional<String>> get snackbar => _snackbarSubject.stream;

  Stream<DateTime> get dateTime => _dateSubject.stream;

  Function(String) get onMeetingsNameChanged => _meetingsName.sink.add;

  Function(String) get changeSearchQuery => _searchQuerySubject.sink.add;

  Stream<List<PlaceRatingItem>> get places => _placesSubject.stream;

  Stream<Optional<PlaceRatingItem>> get chosenPlace =>
      _placesSubject.stream.map((places) {
        if (places.any((place) => place.selected)) {
          return places.firstWhere((place) => place.selected).toOptional();
        } else {
          return Optional.absent();
        }
      });

  void errorHandled() => _snackbarSubject.sink.add(Optional.absent());

  void subscribeToSearchQuery() {
    _searchQuerySubject.debounce(Duration(milliseconds: 100)).listen((value) {
      _onSearchQueryChange(value);
    });
  }

  void _onSearchQueryChange(String value) {
    Future<List<double>> ratingsFuture;
    Future<List<Place>> placesFuture;
    placesFuture = _placeApiService.getPlaceByNameAutoCorrect(value);
    if (value.length >= 3) {
      _placeApiService.getPlaceByNameAutoCorrect(value).then((places) {
        ratingsFuture = Future.wait(places.map((place) {
          return _ratingApiService.getAvgRating(place.id);
        }));
        var list =
            ZipStream.zip2(ratingsFuture.asStream(), placesFuture.asStream(),
                (List<double> ratings, List<Place> places) {
          List<PlaceRatingItem> items = List();
          for (int i = 0; i < places.length; ++i) {
            items.add(PlaceRatingItem(
                places[i].id, places[i].name, ratings[i], false));
          }
          return items;
        });
        // check here because it is async so it will work with fast deleting as well
        list.first.then((items) {
          if (_searchQuerySubject.value.isEmpty) {
            _placesSubject.sink.add(List());
          } else {
            _placesSubject.sink.add(items);
          }
        });
      }).catchError((error) {
        //todo:: implement
      });
    } else if (value.isEmpty) {
      _placesSubject.sink.add(List());
    }
  }

  void onPlaceChosen(PlaceRatingItem selectedItem) {
    final newItem = PlaceRatingItem(
        selectedItem.placeId, selectedItem.name, selectedItem.rating, true);

    final items = _placesSubject.value;

    if (items.any((item) => item.selected)) {
      final currentChosen = items.firstWhere((item) => item.selected);
      final notChosenAnymore = PlaceRatingItem(currentChosen.placeId,
          currentChosen.name, currentChosen.rating, false);
      final currentChosenIndex = items.indexOf(currentChosen);
      items.replaceRange(
          currentChosenIndex, currentChosenIndex + 1, [notChosenAnymore]);
    }

    final indexToAdd =
        items.indexWhere((item) => item.placeId == selectedItem.placeId);
    items.replaceRange(indexToAdd, indexToAdd + 1, [newItem]);

    _placesSubject.sink.add(items);
  }

  Function(DateTime) get onDateTimeChanged => _dateSubject.sink.add;

  void addMeeting() async {
    final date = _dateSubject.value;
    final Optional<PlaceRatingItem> place = await chosenPlace.first;
    int hostId = await getUserId();
    if (_meetingsName.value.isEmpty || date == null || place.isNotPresent) {
      _snackbarSubject.sink
          .add("choose all of : name, date, place".toOptional());
      return;
    }

    String startingTime = date.toIso8601String();
    int placeId = place.value.placeId;
    String name = _meetingsName.value;

    _meetingsApiService
        .createMeeting(hostId, startingTime, placeId, name)
        .then((_) => (_meetingAdded.sink.add(true.toOptional())))
        .catchError((error) =>
            _snackbarSubject.sink.add(error.toString().toOptional()));
  }

  @override
  void dispose() {
    _meetingAdded.close();
    _searchQuerySubject.close();
    _meetingsName.close();
    _placesSubject.close();
    _snackbarSubject.close();
    _dateSubject.close();
  }
}
