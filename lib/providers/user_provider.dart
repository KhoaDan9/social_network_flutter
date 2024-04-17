import 'package:flutter/cupertino.dart';
import 'package:instagramz_flutter/models/user.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get getUser => _user!;

  Future<void> refreshUser() async {
    User user = await AuthMethod().getUserDetails();
    _user = user;
    notifyListeners();
  }
}
