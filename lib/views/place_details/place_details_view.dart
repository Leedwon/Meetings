import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:meetings/models/place.dart';
import 'package:meetings/models/services/place_api_service.dart';
import 'package:meetings/models/services/rating_api_service.dart';
import 'package:meetings/views/place_details/place_details_bloc.dart';
import 'package:meetings/widgets/loading.dart';
import 'package:meetings/widgets/spacing_widget.dart';
import 'package:quiver/core.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final int placeId;

  PlaceDetailsScreen(this.placeId);

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState(placeId);
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  PlaceDetailsBloc _placeDetailsBloc;
  PlaceApiService _placeApiService;
  RatingApiService _ratingApiService;
  int placeId;

  _PlaceDetailsScreenState(this.placeId);

  @override
  void initState() {
    super.initState();
    Client client = Client();
    _placeApiService = PlaceApiService(client);
    _ratingApiService = RatingApiService(client);
    _placeDetailsBloc =
        PlaceDetailsBloc(placeId, _placeApiService, _ratingApiService);
    _placeDetailsBloc.fetchPlace();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place details"),
      ),
      body: Builder(builder: (BuildContext context) {
        _placeDetailsBloc.snackbar.listen((data) {
          if (data.isPresent) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(data.value),
              duration: const Duration(seconds: 3),
            ));
            _placeDetailsBloc.resetSnackbar();
          }
        });
        return StreamBuilder<Optional<PlaceDetails>>(
            stream: _placeDetailsBloc.place,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.isNotPresent) {
                return LoadingWidget();
              } else {
                PlaceDetails place = snapshot.data.value;
                var image = Image.network(place.photoUrl);
                image.image
                    .resolve(ImageConfiguration())
                    .addListener(ImageStreamListener((imageInfo, b) {
                  if (mounted) {
                    _placeDetailsBloc.onImageLoaded(true);
                  }
                }));
                return Column(
                  children: <Widget>[
                    StreamBuilder<bool>(
                      stream: _placeDetailsBloc.imageLoaded,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data) {
                          return Image.network(place.photoUrl);
                        } else {
                          return Container();
                        }
                      },
                    ),
                    SpacingWidget(
                        bottomSpacing: 16.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              place.name,
                              style: TextStyle(fontSize: 24.0),
                            ),
                            Icon(Icons.star, color: Colors.amber),
                            Text(place.rating.toString())
                          ],
                        )),
                    SpacingWidget(
                      bottomSpacing: 8.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(
                              Icons.place,
                              color: Colors.blue,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              "${place.streetName} ${place.streetNumber} ${place.postalCode}",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed('/mapWithPlace', arguments: LatLng(place.latitude, place.longitude)),
                              child: Text(
                                "show on map",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.blue),
                              )),
                        ],
                      ),
                    ),
                    SpacingWidget(
                      bottomSpacing: 8.0,
                      child: RatingBar(
                        onRatingUpdate: (rating) =>
                            _placeDetailsBloc.onRatingUpdated(rating),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        allowHalfRating: false,
                      ),
                    ),
                    SpacingWidget(
                      bottomSpacing: 8.0,
                      child: GestureDetector(
                          onTap: () => _placeDetailsBloc.rate(),
                          child: Text(
                            "rate",
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.blue),
                          )),
                    )
                  ],
                );
              }
            });
      }),
    );
  }

  @override
  void dispose() {
    _placeDetailsBloc.dispose();
    super.dispose();
  }
}
