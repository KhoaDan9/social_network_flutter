import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramz_flutter/models/post.dart';
import 'package:instagramz_flutter/models/user.dart' as model;
import 'package:instagramz_flutter/resources/auth_method.dart';
import 'package:instagramz_flutter/resources/storage_method.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v1.dart';

class FireStoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadPost(
    Uint8List? file,
    String description,
  ) async {
    try {
      String photoUrl;
      final user = await AuthMethod().getUserDetails();
      if (file != null) {
        photoUrl = await StorageMethods()
            .uploadImageToStorage('posts/${user.uid}', file, true);
      } else {
        photoUrl = "";
      }

      String postId = const Uuid().v1();
      Post post = Post(
        postId: postId,
        uid: user.uid,
        description: description,
        username: user.username,
        likes: const [],
        datePublished: DateTime.now(),
        postPhotoUrl: photoUrl,
        userPhotoUrl: user.photoUrl,
      );

      await _firestore.collection('posts').doc(post.postId).set(post.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }
}