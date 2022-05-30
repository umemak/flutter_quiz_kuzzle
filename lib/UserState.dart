import 'package:flutter/material.dart';
import 'package:kuzzle/kuzzle.dart';

class UserState extends ChangeNotifier {
  KuzzleUser? user;
  KuzzleUser? player;

  void setUser(KuzzleUser newUser) {
    user = newUser;
    notifyListeners();
  }

  void setPlayer(KuzzleUser newUser) {
    player = newUser;
    notifyListeners();
  }
}
