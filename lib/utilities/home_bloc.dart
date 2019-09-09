import 'dart:async';

import 'package:wisapedia/utilities/bloc_provider.dart';

class HomeBloc extends BlocBase {
  String id, token;
  UserInfo info;
  StreamController<UserInfo> _streamController =
      new StreamController.broadcast();

  Stream get stream => _streamController.stream;

  setUser(UserInfo ui) {
    info = ui;
    _streamController.add(ui);
  }

  @override
  void dispose() {
    _streamController.close();
  }
}

class UserInfo {
  String id;
  String name;
  String email;
  String number;
  DateTime birthDay;

  UserInfo.fromJson(json) {
    id = json["_id"].toString();
    name = json["name"].toString();
    email = json["email"];
    number = json["number"].toString();
    birthDay = DateTime.parse(json["birthday"]);
  }
}
