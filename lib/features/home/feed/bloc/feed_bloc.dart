import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramz_flutter/features/home/feed/bloc/feed_event.dart';
import 'package:instagramz_flutter/features/home/feed/bloc/feed_state.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final FireStoreMethod fireStoreMethod;
  FeedBloc({required this.fireStoreMethod}) : super(const FeedState()) {
    on<DeletePostOnClickEvent>((event, emit) async {
      try {
        await FireStoreMethod().deletePost(event.postId, event.photoUrl);
        emit(const DeletePostSuccess(message: 'Delete post successfully'));
      } on FirebaseException catch (e) {
        print(e.code);
      }
    });

    on<ChangeFeedState>((event, emit) async {
      emit(const FeedState());
    });

    on<FollowOnClickEvent>((event, emit) async {
      try {
        String state =
            await FireStoreMethod().followUser(event.userId, event.uid);
        emit(FollowSuccess(message: state));
      } on FirebaseException catch (e) {
        print(e.code);
      }
    });

    on<ProfileOnClickEvent>((event, emit) {
      emit(ProfilePostsState(uid: event.uid));
    });

    on<FeedOnClickEvent>((event, emit) {
      emit(const FeedState());
    });
  }
}
