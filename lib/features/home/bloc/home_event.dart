import 'package:equatable/equatable.dart';
import 'package:instagramz_flutter/models/user_model.dart';

abstract class HomeEvent extends Equatable {
  final UserModel? user;
  const HomeEvent({this.user});

  @override
  List<Object?> get props => [user];
}

class SetUser extends HomeEvent {
  const SetUser({required super.user});

  @override
  List<Object?> get props => [user];
}

class PageTapped extends HomeEvent {
  final int pageIndex;
  const PageTapped({required this.pageIndex});

  @override
  List<Object?> get props => [pageIndex];
}
