import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterOnClickEvent extends RegisterEvent {
  final String email;
  final String fullname;
  final String username;
  final String password;
  final Uint8List image;

  const RegisterOnClickEvent({
    required this.email,
    required this.fullname,
    required this.username,
    required this.password,
    required this.image,
  });

  @override
  List<Object?> get props => [email, fullname, username, password, image];
}

class RefreshRegisterEvent extends RegisterEvent {
  const RefreshRegisterEvent();

  @override
  List<Object?> get props => [];
}
