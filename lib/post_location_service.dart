import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:meetings/utils/shared_preferences_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/services/user_api_service.dart';

class PostLocationService {
  PostLocationService._privateConstructor();

  static void init() {
    if (!_initialized) {
      Location location = Location();
      UserApiService userApiService = UserApiService(Client());
      location.requestPermission().then((granted) {
        if (granted) {
          location.onLocationChanged().listen((location) async {
            if (_currentLocation == null ||
                _currentLocation.didLatLngChange(location)) {
              _currentLocation = location;
              print(
                  "location changed to lat,lng ${location.latitude}, ${location.longitude}");
              int userId = await getUserId();
              userApiService.updateLocalization(userId, location.latitude, location.longitude);
            }
          });
        }
      });
      _initialized = true;
    }
  }

  static LocationData _currentLocation;

  static bool _initialized = false;

  static final PostLocationService _instance =
      PostLocationService._privateConstructor();

  static PostLocationService get instance {
    return _instance;
  }
}

Future<int> getUserId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  int id = preferences.getInt(USER_ID);
  print("reading user id = $id");
  return id;
}

extension LocationDataComparator on LocationData {
  bool didLatLngChange(LocationData locationData) =>
      this.latitude != locationData.latitude ||
      this.longitude != locationData.longitude;
}
