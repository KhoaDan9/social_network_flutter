import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramz_flutter/models/comment.dart';
import 'package:instagramz_flutter/models/post.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';
import 'package:instagramz_flutter/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection("posts").doc(postId).delete();
      _firestore
          .collection("comments")
          .where('postId', isEqualTo: postId)
          .get()
          .then(
            (querySnapshot) => {
              querySnapshot.docs.forEach(
                (comment) {
                  comment.reference.delete();
                },
              )
            },
          );
    } catch (e) {
      print(e);
    }
  }

  Future<void> storeComment(String postId, String content) async {
    try {
      final user = await AuthMethod().getUserDetails();
      String commentId = const Uuid().v1();
      Comment cmt = Comment(
        commentId: commentId,
        postId: postId,
        uid: user.uid,
        username: user.username,
        content: content,
        likes: const [],
        userPhotoUrl: user.photoUrl,
        datePublished: DateTime.now(),
      );
      await _firestore.collection('comments').doc(commentId).set(cmt.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<int> getCommentNum(String postId) async {
    QuerySnapshot snap = await _firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .orderBy('datePublished', descending: true)
        .get();
    return snap.docs.length;
  }

  Future<void> likeComment(String cmtId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('comments').doc(cmtId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('comments').doc(cmtId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
