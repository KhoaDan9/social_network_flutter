// import 'package:flutter/cupertino.dart';
// import 'package:instagramz_flutter/models/user_model.dart';
// import 'package:instagramz_flutter/resources/auth_method.dart';

// class UserProvider with ChangeNotifier {
//   UserModel? _user;

//   UserModel get getUser => _user!;

//   Future<void> refreshUser() async {
//     UserModel user = await AuthMethod().getUserDetails();
//     _user = user;
//     notifyListeners();
//   }
// }
