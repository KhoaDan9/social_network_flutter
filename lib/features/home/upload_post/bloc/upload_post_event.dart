import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class UploadPostEvent extends Equatable {
  const UploadPostEvent();

  @override
  List<Object?> get props => [];
}

class UploadPostOnClickEvent extends UploadPostEvent {
  final Uint8List? file;
  final String description;
  const UploadPostOnClickEvent({this.file, required this.description});

  @override
  List<Object?> get props => [file, description];
}
