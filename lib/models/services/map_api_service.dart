import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';

class MapApiService{
  final Client client;
  final String url = "my_awesome_url";

  MapApiService(this.client);

  Future<List<LatLng>> getMarkers() async{
    return Future.delayed(const Duration(seconds: 2), () => [LatLng(50.049683, 19.944544)]);
  }
}