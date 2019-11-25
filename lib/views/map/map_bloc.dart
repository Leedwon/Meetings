import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meetings/models/services/map_api_service.dart';
import './bloc.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final MapApiService mapApiService;

  MapBloc(this.mapApiService);

  @override
  MapState get initialState => MarkersLoading();

  @override
  Stream<MapState> mapEventToState(
    MapEvent event,
  ) async* {
    print(event.toString());
    if (event is MapOpened) {
      yield* _mapMapOpenedToState();
    }
  }

  Stream<MapState> _mapMapOpenedToState() async* {
    final markers = await mapApiService.getMarkers();
    yield MarkersLoaded(markers);
  }
}
