import 'dart:async';

import 'package:meetings/models/services/user_api_service.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';

import '../base_bloc.dart';

class LoginBloc extends BaseBloc {
  final UserApiService userApiService;

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _loggedInSubject = BehaviorSubject<bool>();
  final _errorSubject = BehaviorSubject<Optional<String>>.seeded(
      Optional.absent());

  LoginBloc(this.userApiService);

  final emailErrorTransformer =
  StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains('@')) {
      sink.add(email);
    } else {
      sink.addError('Invalid email');
    }
  });

  final passwordErrorTransformer =
  StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
        if (password.length >= 6) {
          sink.add(password);
        } else {
          sink.addError('Password must contains at least 6 characters');
        }
      });

  Stream<bool> get loggedIn => _loggedInSubject.stream;

  Stream<Optional<String>> get error => _errorSubject.stream;

  Stream<String> get email =>
      _emailController.stream.transform(emailErrorTransformer);

  Stream<String> get password =>
      _passwordController.stream.transform(passwordErrorTransformer);

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  void errorHandled() {
    _errorSubject.sink.add(Optional.absent());
  }

  Stream<bool> get isValid =>
      Observable.combineLatest2(
          _emailController,
          _passwordController,
              (String email, String password) =>
          email.length >= 0 && email.contains('@') && password.length >= 6);

  submit() async {
    print("submited");
    userApiService.login(_emailController.value, _passwordController.value)
        .then((id) async {
      setUserId(id);
      _loggedInSubject.sink.add(true);
    })
        .catchError((error) {
      _errorSubject.sink.add(Optional.of(error.toString()));
    });
  }


  @override
  dispose() {
    _emailController.close();
    _passwordController.close();
    _loggedInSubject.close();
    _errorSubject.close();
  }
}
