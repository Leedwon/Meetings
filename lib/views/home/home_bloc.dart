import 'package:meetings/models/place.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/rating_api_service.dart';
import 'package:meetings/widgets/place_rating.dart';
import 'package:rxdart/rxdart.dart';

import '../base_bloc.dart';

class HomeBloc extends BaseBloc {
  final PlaceApiService _placeApiService;
  final RatingApiService _ratingApiService;

  HomeBloc(this._placeApiService, this._ratingApiService);

  final BehaviorSubject<List<PlaceRatingItem>> _placesSubject =
      BehaviorSubject.seeded(List());

  final BehaviorSubject<String> _searchQuerySubject =
      BehaviorSubject.seeded("");

  Function(String) get changeSearchQuery => _searchQuerySubject.sink.add;

  Stream<List<PlaceRatingItem>> get places => _placesSubject.stream;

  void subscribeToSearchQuery() {
    _searchQuerySubject.debounce(Duration(milliseconds: 100)).listen((value) {
      _onSearchQueryChange(value);
    });
  }

  void resetUserId() => setUserId(null);

  void _onSearchQueryChange(String value) {
    print("query length = ${value.length}");
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
        list.first.then((items) {
          // check here because it is async so it will work with fast deleting as well
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

  void getAllMeetings() async {
    Future<List<double>> ratingsFuture;
    Future<List<Place>> placesFuture;
    placesFuture = _placeApiService.getAllPlaces();
    _placeApiService.getAllPlaces().then((places) {
      ratingsFuture = Future.wait(places.map((place) {
        return _ratingApiService.getAvgRating(place.id);
      }));
      var list =
          ZipStream.zip2(ratingsFuture.asStream(), placesFuture.asStream(),
              (List<double> ratings, List<Place> places) {
        List<PlaceRatingItem> items = List();
        for (int i = 0; i < places.length; ++i) {
          items.add(
              PlaceRatingItem(places[i].id, places[i].name, ratings[i], false));
        }
        return items;
      });
      list.first.then((items) {
        // check here because it is async so it will work with fast dele
        _placesSubject.sink.add(items);
      });
    });
  }

  @override
  void dispose() {
    _placesSubject.close();
    _searchQuerySubject.close();
  }
}
