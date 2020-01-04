import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:meetings/models/user.dart';
import 'package:meetings/utils/shared_preferences_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bloc.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserApiService _userApiService;

  ProfileBloc(this._userApiService);

  @override
  ProfileState get initialState => ProfileLoading();

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
     print(event.toString());
     if(event is ProfileOpened){
       yield* _mapProfileOpenedToState();
     }
  }

  Stream<ProfileState> _mapProfileOpenedToState() async* {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = await _userApiService.getUser(preferences.getDouble(USER_ID));
    yield ProfileLoaded(user.pseudonym, user.email);
  }
}
