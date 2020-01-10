import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:meetings/utils/network_utils.dart';

class MapApiService{
  final Client client;
  final String url = "$BASE_URL";

  MapApiService(this.client);

  Future<List<LatLng>> getMarkers() async{
    return Future.delayed(const Duration(seconds: 2), () => [LatLng(50.049683, 19.944544)]);
  }
}