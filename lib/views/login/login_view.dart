import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetings/icons/meetings_icons.dart';
import 'package:meetings/views/login/login_bloc.dart';
import 'package:meetings/models/services/user_api_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _client = Client();
  var _isPasswordVisible = false;
  UserApiService _apiService;
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();
    _apiService = UserApiService(_client);
    _loginBloc = LoginBloc(_apiService);
    _loginBloc.loggedIn.listen((loggedIn) {
      if (loggedIn) {
        Navigator.pushReplacementNamed(context, '/logged_in');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Builder(
          builder: (BuildContext context) {
            _loginBloc.error.listen((element) {
              if (element.isPresent) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(element.value),
                  duration: const Duration(seconds: 3),
                ));
                _loginBloc.errorHandled();
              }
            });
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    emailField(_loginBloc),
                    passwordField(_loginBloc),
                    submitButton(_loginBloc),
                    registerField(),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget emailField(LoginBloc bloc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: StreamBuilder(
          stream: bloc.email,
          builder: (context, snapshot) {
            return TextField(
              onChanged: bloc.changeEmail,
              decoration:
                  InputDecoration(hintText: "Email", errorText: snapshot.error),
            );
          }),
    );
  }

  Widget passwordField(LoginBloc bloc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: StreamBuilder(
          stream: bloc.password,
          builder: (context, snapshot) {
            return TextField(
              obscureText: _isPasswordVisible ? false : true,
              onChanged: bloc.changePassword,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                        _isPasswordVisible ? Meetings.eye_off : Meetings.eye),
                    iconSize: 16.0,
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  hintText: "Password",
                  errorText: snapshot.error),
            );
          }),
    );
  }

  Widget submitButton(LoginBloc bloc) {
    final errorSnackbar = SnackBar(
        content: Text('Enter valid data to login'),
        duration: const Duration(seconds: 3));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: StreamBuilder(
        stream: bloc.isValid,
        builder: (context, snapshot) {
          return Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('Login'),
                  color: Colors.blue,
                  onPressed: snapshot.hasData && snapshot.data == true
                      ? bloc.submit
                      : () =>
                          Scaffold.of(context).showSnackBar(errorSnackbar)));
        },
      ),
    );
  }

  Widget registerField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
          child: Text("Don't have account yet? register",
              style: TextStyle(color: Colors.blue))),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
