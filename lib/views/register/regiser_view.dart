import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:meetings/icons/meetings_icons.dart';
import 'package:meetings/models/services/user_api_service.dart';
import 'package:meetings/views/register/register_bloc.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _client = Client();
  var _isPasswordVisible = false;
  UserApiService _apiService;
  RegisterBloc _registerBloc;

  @override
  void initState() {
    super.initState();
    _apiService = UserApiService(_client);
    _registerBloc = RegisterBloc(_apiService);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                emailField(_registerBloc),
                passwordField(_registerBloc),
                submitButton(_registerBloc),
                registerField()
              ],
            ),
          ),
        ));
  }

  Widget emailField(RegisterBloc bloc) {
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

  Widget passwordField(RegisterBloc bloc) {
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

  Widget submitButton(RegisterBloc bloc) {
    final errorSnackbar = SnackBar(
        content: Text('Enter valid data to register'),
        duration: const Duration(seconds: 3));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: StreamBuilder(
        stream: bloc.isValid,
        builder: (context, snapshot) {
          return Container(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('Register'),
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
            Navigator.pop(context);
          },
          child: Text("Have account already? Login",
              style: TextStyle(color: Colors.blue))),
    );
  }

  @override
  void dispose() {
    _registerBloc.dispose();
    super.dispose();
  }
}
