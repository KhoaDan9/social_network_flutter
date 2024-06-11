import 'package:equatable/equatable.dart';
import 'package:instagramz_flutter/models/user_model.dart';

class LoginState extends Equatable {
  final bool isLoading;
  const LoginState({this.isLoading = false});

  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final UserModel user;
  const LoginSuccess({required this.user, super.isLoading});
}

class LoginFailure extends LoginState {
  final String exception;
  const LoginFailure({required this.exception, super.isLoading});
}
