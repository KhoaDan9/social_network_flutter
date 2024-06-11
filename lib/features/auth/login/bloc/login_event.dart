import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginOnClickEvent extends LoginEvent {
  final String email;
  final String password;
  const LoginOnClickEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class GoToRegisterEvent extends LoginEvent {
  const GoToRegisterEvent();
}
