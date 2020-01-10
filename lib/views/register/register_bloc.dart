import 'dart:async';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:quiver/core.dart';
import 'package:rxdart/rxdart.dart';
import '../base_bloc.dart';

class RegisterBloc extends BaseBloc {
  final UserApiService userApiService;

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _pseudonymController = BehaviorSubject<String>();
  final _errorController =
      BehaviorSubject<Optional<String>>.seeded(Optional.absent());
  final _registeredSubject = BehaviorSubject<bool>();

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

  final pseudonymTransformer = StreamTransformer<String, String>.fromHandlers(
      handleData: (pseudonym, sink) {
    if (pseudonym.length >= 3) {
      sink.add(pseudonym);
    } else {
      sink.addError('Nickname must contains at least 3 characters');
    }
  });

  Stream<bool> get registered => _registeredSubject.stream;

  Stream<String> get email =>
      _emailController.stream.transform(emailErrorTransformer);

  Stream<String> get password =>
      _passwordController.stream.transform(passwordErrorTransformer);

  Stream<String> get pseudonym =>
      _pseudonymController.stream.transform(pseudonymTransformer);

  Stream<Optional<String>> get error => _errorController.stream;

  Function(String) get changeEmail => _emailController.sink.add;

  Function(String) get changePassword => _passwordController.sink.add;

  Function(String) get changePseudonym => _pseudonymController.sink.add;

  Stream<bool> get isValid => Observable.combineLatest3(
      _emailController,
      _passwordController,
      _pseudonymController,
      (String email, String password, String pseudonym) =>
          email.contains('@') && password.length >= 6 && pseudonym.length >= 3);

  submit() async {
    print("submited");
    userApiService
        .register(_emailController.value, _pseudonymController.value,
            _passwordController.value)
        .then((id) async {
      setUserId(id);
      _registeredSubject.sink.add(true);
    }).catchError((error) {
      _errorController.sink.add(Optional.of(error.toString()));
    });
  }

  @override
  dispose() {
    _emailController.close();
    _passwordController.close();
    _pseudonymController.close();
    _errorController.close();
    _registeredSubject.close();
  }
}
