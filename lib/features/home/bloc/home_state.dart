import 'package:equatable/equatable.dart';
import 'package:instagramz_flutter/models/user_model.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final UserModel? user;
  const HomeState({this.user, this.isLoading = false});

  @override
  List<Object?> get props => [user];
}

class HomePage extends HomeState {
  final int pageIndex;
  const HomePage({required this.pageIndex, super.user});

  @override
  List<Object?> get props => [pageIndex, user];
}

class UploadPostSuccess extends HomeState {
  final String message;
  const UploadPostSuccess({required this.message, super.isLoading});

  @override
  List<Object?> get props => [user];
}

class UploadPostFailure extends HomeState {
  final String exception;
  const UploadPostFailure({required this.exception, super.isLoading});
}
