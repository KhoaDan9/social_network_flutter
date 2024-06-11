import 'package:equatable/equatable.dart';
import 'package:instagramz_flutter/models/user_model.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class SetUser extends HomeEvent {
  final UserModel user;
  const SetUser({required this.user});

  @override
  List<Object?> get props => [user];
}
