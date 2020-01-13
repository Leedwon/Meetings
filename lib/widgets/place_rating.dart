import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class PlaceRatingItem {
  final int placeId;
  final String name;
  final double rating;
  final bool selected;

  PlaceRatingItem(this.placeId, this.name, this.rating, this.selected);
}

class PlaceRatingWidget extends StatelessWidget {
  final PlaceRatingItem _placeRating;
  final Function(PlaceRatingItem) onPlaceSelected;

  PlaceRatingWidget(this._placeRating, this.onPlaceSelected);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPlaceSelected(_placeRating),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
                color: _placeRating.selected ? Colors.blue : Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
              child: Text(
                _placeRating.name,
                style: TextStyle(fontSize: 20.0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 8.0),
              child: RatingBar(
                onRatingUpdate: (_) => {},
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                ignoreGestures: true,
                initialRating: _placeRating.rating,
                allowHalfRating: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}
