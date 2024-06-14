import 'package:equatable/equatable.dart';

class FeedState extends Equatable {
  final bool isLoading;
  final String? message;
  const FeedState({this.isLoading = false, this.message});

  @override
  List<Object?> get props => [];
}

class AllPostsState extends FeedState {
  const AllPostsState({super.isLoading});

  @override
  List<Object?> get props => [];
}

class ProfilePostsState extends FeedState {
  final String uid;
  const ProfilePostsState({required this.uid, super.isLoading});

  @override
  List<Object?> get props => [uid];
}

class DeletePostSuccess extends FeedState {
  @override
  final String message;
  const DeletePostSuccess({required this.message, super.isLoading});

  @override
  List<Object?> get props => [message];
}

class FollowSuccess extends FeedState {
  @override
  final String message;
  const FollowSuccess({required this.message, super.isLoading});

  @override
  List<Object?> get props => [message];
}
