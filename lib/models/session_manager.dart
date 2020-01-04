import 'package:meetings/models/user.dart';

class SessionManager {
  User user;

  User getUser() => user;

  void setUser(User user){
    this.user = user;
  }

  static final SessionManager _instance = SessionManager._internal();

  SessionManager._internal();

  static SessionManager get instance => _instance;

}