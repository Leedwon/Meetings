import 'dart:async';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc {
 final UserApiService userApiService;

  final _emailController = BehaviorSubject<String>();
  final _emailFocusController = BehaviorSubject<bool>();
  final _passwordController = BehaviorSubject<String>();

  RegisterBloc(this.userApiService);

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

  Stream<String> get email =>
      _emailController.stream.transform(emailErrorTransformer);

  Stream<String> get password =>
    _passwordController.stream.transform(passwordErrorTransformer);

  Function(bool) get changeEmailFocus => _emailFocusController.sink.add;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  Stream<bool> get isValid => Observable.combineLatest2(
      _emailController,
      _passwordController,
      (String email, String password) =>
          email.contains('@') && password.length >= 6);

  submit() {
    print("submited");
    //todo:: perform registring account
  }

  dispose() {
    _emailController.close();
    _passwordController.close();
    _emailFocusController.close();
  }


}