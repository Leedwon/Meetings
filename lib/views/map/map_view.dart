import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:meetings/models/services/map_api_service.dart';
import 'package:meetings/widgets/loading.dart';
import 'package:meetings/widgets/map.dart';
import 'bloc.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  MapScreen({Key key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static final String toolbarTitle = "Maps";
  MapBloc _mapBloc;

  @override
  void initState() {
    super.initState();
    _mapBloc = MapBloc(MapApiService(Client())); //todo:: refactor this no di madness
    _mapBloc.dispatch(MapOpened());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(toolbarTitle)),
      body: BlocBuilder(
        bloc: _mapBloc,
        // ignore: missing_return
        builder: (BuildContext context, MapState state) {
          if (state is MarkersLoading) {
            return LoadingWidget();
          }
          if (state is MarkersLoaded) {
            return MapWidget(state.markers);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapBloc.dispose();
    super.dispose();
  }
}
