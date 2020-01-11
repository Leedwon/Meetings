import 'package:http/http.dart';
import 'package:meetings/utils/network_utils.dart';

class RatingApiService {
  final Client client;
  final String url = "$BASE_URL/rate";

  RatingApiService(this.client);

  Future<double> getAvgRating(int placeId) async {
    final Response response = await client.get(
        "$url/get/avarageRate?id=$placeId");
    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      Future.error("couldn't get rating");
    }
  }

  Future<bool> rate(double mark, int userId, int placeId) async {
    final Response response = await client.get("$url/post/createRate?mark=$mark&userid=$userId.5&placeid=$placeId");
    if(response.statusCode == 200){
      return true;
    } else {
      Future.error("couldn't rate this place");
    }
  }
}