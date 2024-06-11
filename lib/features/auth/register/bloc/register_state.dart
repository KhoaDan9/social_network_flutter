import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isLoading;
  const RegisterState({this.isLoading = false});

  @override
  List<Object?> get props => [];
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess({super.isLoading});

  @override
  List<Object?> get props => [];
}

class RegisterFailure extends RegisterState {
  final String exception;
  const RegisterFailure({required this.exception, super.isLoading});

  @override
  List<Object?> get props => [exception];
}
