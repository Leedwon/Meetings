import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MapState extends Equatable {
  MapState([List props = const <dynamic>[]]) : super();
}

class MarkersLoading extends MapState {
  @override
  String toString() => 'MarkersLoading';

  @override
  List<Object> get props => Iterable.empty();
}

class MarkersLoaded extends MapState {
  final List<LatLng> markers;

  MarkersLoaded(this.markers);

  @override
  String toString() => 'MarkersLoaded';

  @override
  List<Object> get props => [markers];
}
