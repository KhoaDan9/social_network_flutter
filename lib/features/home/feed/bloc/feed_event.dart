import 'package:equatable/equatable.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllPostsEvent extends FeedEvent {
  const LoadAllPostsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfilePostsEvent extends FeedEvent {
  final String uid;
  const LoadProfilePostsEvent({required this.uid});

  @override
  List<Object?> get props => [uid];
}

class DeletePostOnClickEvent extends FeedEvent {
  final String postId;
  final String photoUrl;
  const DeletePostOnClickEvent({required this.postId, required this.photoUrl});

  @override
  List<Object?> get props => [postId, photoUrl];
}

class FollowOnClickEvent extends FeedEvent {
  final String userId;
  final String uid;
  final List following;

  const FollowOnClickEvent({
    required this.userId,
    required this.uid,
    required this.following,
  });

  @override
  List<Object?> get props => [userId, uid, following];
}

class ChangeFeedState extends FeedEvent {
  const ChangeFeedState();

  @override
  List<Object?> get props => [];
}

class FeedOnClickEvent extends FeedEvent {
  const FeedOnClickEvent();

  @override
  List<Object?> get props => [];
}

class ProfileOnClickEvent extends FeedEvent {
  final String uid;
  const ProfileOnClickEvent({required this.uid});

  @override
  List<Object?> get props => [uid];
}
