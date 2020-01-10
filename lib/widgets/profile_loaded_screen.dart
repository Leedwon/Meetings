import 'package:flutter/material.dart';
import 'package:meetings/views/profile/profile_bloc.dart';

class ProfileLoadedScreen extends StatelessWidget {
  final ProfileState _state;
  final Function(String) onFriendNameChanged;
  final Function onAddClick;
  final Function(String) onFriendSwapped; // todo:: use id instead of email?

  ProfileLoadedScreen(this._state,
      {this.onFriendNameChanged, this.onAddClick, this.onFriendSwapped});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircleAvatar(
                  minRadius: 24.0,
                  child: Text(
                    _state.pseudonym[0].toUpperCase(),
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
              ),
              Text(
                _state.pseudonym,
                style: TextStyle(fontSize: 20.0),
              ),
              Text(
                _state.email,
                style: TextStyle(fontSize: 20.0),
              )
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Text(
                    "add friend",
                    style: TextStyle(
                        fontSize: 20.0, color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        enabled: !_state.buttonLoading,
                        onChanged: onFriendNameChanged,
                        decoration: InputDecoration(
                            hintText: "Friend's email",
                            errorText: _state.error),
                      ),
                    ),
                    _getButton(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: Text(
                    "friends :",
                    style: TextStyle(
                        fontSize: 20.0, color: Colors.black.withOpacity(0.6)),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _state.friends.length,
                      itemBuilder: (BuildContext context, int index) {
                        var email = _state.friends[index].email;
                        return Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Dismissible(
                            key: Key(_state.friends[index].id.toString()),
                            onDismissed: (dismissDirection) => onFriendSwapped(email),
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_state.friends[index]?.pseudonym ?? ""),
                                  Text(_state.friends[index].email ?? "")
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getButton() {
    if (_state.buttonLoading) {
      return CircularProgressIndicator();
    } else {
      return RawMaterialButton(
        onPressed: () => onAddClick(),
        child: new Icon(
          Icons.add,
          color: Colors.blue,
          size: 25.0,
        ),
        shape: new CircleBorder(),
        elevation: 2.0,
        fillColor: Colors.white,
        padding: const EdgeInsets.all(15.0),
      );
    }
  }
}
