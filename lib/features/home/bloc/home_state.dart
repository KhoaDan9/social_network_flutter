import 'package:equatable/equatable.dart';
import 'package:instagramz_flutter/models/user_model.dart';

class HomeState extends Equatable {
  final UserModel? user;
  const HomeState({this.user});

  @override
  List<Object?> get props => [user];
}
