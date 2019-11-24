import 'package:http/http.dart';

class UserApiService {
  final Client client;
  final String url = "my_awesome_url";
  
  UserApiService(
    this.client,
  );

  Future<String> login(String email, String password) async {
    final response = await client.get("$url/loginEndpoint");
    if(response.statusCode == 200){
      return response.body;
    } else {
      throw Exception('Login failed');
    }
  }
}