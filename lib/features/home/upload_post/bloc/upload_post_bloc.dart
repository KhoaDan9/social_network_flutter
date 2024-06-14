import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramz_flutter/features/home/upload_post/bloc/upload_post_event.dart';
import 'package:instagramz_flutter/features/home/upload_post/bloc/upload_post_state.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';

class UploadPostBloc extends Bloc<UploadPostEvent, UploadPostState> {
  final FireStoreMethod fireStoreMethod;

  UploadPostBloc({required this.fireStoreMethod})
      : super(const UploadPostState()) {
    on<UploadPostOnClickEvent>((event, emit) async {
      try {
        emit(const UploadPostState(isLoading: true));
        await fireStoreMethod.uploadPost(event.file, event.description);
        emit(const UploadPostSuccess(
            message: "Your post has been posted successfully",
            isLoading: false));
      } on FirebaseException catch (e) {
        emit(UploadPostFailure(exception: e.code, isLoading: false));
      } catch (e) {
        emit(UploadPostFailure(exception: e.toString(), isLoading: false));
      }
    });
  }
}
