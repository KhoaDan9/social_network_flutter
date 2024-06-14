import 'package:equatable/equatable.dart';

class UploadPostState extends Equatable {
  final bool isLoading;
  const UploadPostState({this.isLoading = false});

  @override
  List<Object?> get props => [];
}

class UploadPostSuccess extends UploadPostState {
  final String message;
  const UploadPostSuccess({required this.message, super.isLoading});

  @override
  List<Object?> get props => [message];
}

class UploadPostFailure extends UploadPostState {
  final String exception;
  const UploadPostFailure({required this.exception, super.isLoading});
}
