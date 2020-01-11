import 'package:meetings/models/place.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/rating_api_service.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meetings/utils/common.dart';

import '../base_bloc.dart';

class PlaceDetails {
  final int id;
  final String name;
  final String photoUrl;
  final String streetName;
  final int streetNumber;
  final String postalCode;
  final double latitude;
  final double longitude;
  final double rating;

  PlaceDetails(
      {this.id,
      this.name,
      this.photoUrl,
      this.streetName,
      this.streetNumber,
      this.postalCode,
      this.latitude,
      this.longitude,
      this.rating});
}

class PlaceDetailsBloc extends BaseBloc {
  int placeId;
  PlaceApiService _placeApiService;
  RatingApiService _ratingApiService;

  PlaceDetailsBloc(this.placeId, this._placeApiService, this._ratingApiService);

  BehaviorSubject<Optional<PlaceDetails>> _placeDetails =
      BehaviorSubject.seeded(Optional.absent());

  PublishSubject<Optional<String>> _snackbarSubject = PublishSubject();

  BehaviorSubject<Optional<double>> _rating =
      BehaviorSubject.seeded(Optional.absent());

  BehaviorSubject<bool> _imageLoaded = BehaviorSubject.seeded(false);

  Stream<Optional<PlaceDetails>> get place => _placeDetails.stream;

  Stream<Optional<String>> get snackbar => _snackbarSubject.stream;

  Stream<bool> get imageLoaded => _imageLoaded.stream;

  Function(bool) get onImageLoaded => _imageLoaded.sink.add;

  void onRatingUpdated(double rating) => _rating.sink.add(rating.toOptional());

  void resetSnackbar() => _snackbarSubject.sink.add(Optional.absent());

  void fetchPlace() async {
    Place place = await _placeApiService.getPlaceById(placeId);
    double rating = await _ratingApiService.getAvgRating(placeId);
    _placeDetails.sink.add(PlaceDetails(
            id: place.id,
            name: place.name,
            photoUrl: place.photoUrl,
            streetName: place.streetName,
            streetNumber: place.streetNumber,
            postalCode: place.postalCode,
            latitude: place.latitude,
            longitude: place.longitude,
            rating: rating)
        .toOptional());
  }

  void rate() async {
    final rating = _rating.value;
    if (rating.isPresent) {
      int userId = await getUserId();
      _ratingApiService.rate(rating.value, userId, placeId).then((success) {
        _snackbarSubject.sink.add("place rated".toOptional());
        _updateRating();
      });
    }
  }

  void _updateRating() async {
    PlaceDetails place = _placeDetails.value.value;
    double rating = await _ratingApiService.getAvgRating(placeId);
    _placeDetails.sink.add(PlaceDetails(
            id: place.id,
            name: place.name,
            photoUrl: place.photoUrl,
            streetName: place.streetName,
            streetNumber: place.streetNumber,
            postalCode: place.postalCode,
            latitude: place.latitude,
            longitude: place.longitude,
            rating: rating)
        .toOptional());
  }

  @override
  void dispose() {
    _rating.close();
    _imageLoaded.close();
    _snackbarSubject.close();
    _placeDetails.close();
  }
}
