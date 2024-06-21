import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagramz_flutter/models/comment.dart';
import 'package:instagramz_flutter/models/message.dart';
import 'package:instagramz_flutter/models/messagebox.dart';
import 'package:instagramz_flutter/models/post_model.dart';
import 'package:instagramz_flutter/models/user_model.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';
import 'package:instagramz_flutter/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Stream methods

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamAllPosts() {
    try {
      return _firestore
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamProfilePosts(
      String uid) {
    try {
      return FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .orderBy(
            'datePublished',
            descending: true,
          )
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamUserByUid(
      String uid) {
    try {
      return _firestore.collection('users').doc(uid).snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getStreamMessageByMessageBox(
      String msgBoxId) {
    try {
      return _firestore
          .collection('message')
          .where('messageBoxId', isEqualTo: msgBoxId)
          .orderBy('dateSend', descending: false)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentByPostId(
      String postId) {
    try {
      return FirebaseFirestore.instance
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .orderBy('datePublished', descending: true)
          .snapshots();
    } catch (e) {
      rethrow;
    }
  }

  //Future method

  //Post method
  Future<void> uploadPost(
    Uint8List? file,
    String description,
  ) async {
    try {
      if (description == '' && file == null) {
        throw Exception("Input required");
      }

      String photoUrl;
      final user = await AuthMethod().getUserDetails();
      if (file != null) {
        photoUrl = await StorageMethods()
            .uploadImageToStorage('posts/${user.uid}', file, true);
      } else {
        photoUrl = "";
      }

      String postId = const Uuid().v1();
      PostModel post = PostModel(
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
      // print(e);
      rethrow;
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<void> deletePost(String postId, String imgUrl) async {
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
      if (imgUrl != "") {
        FirebaseStorage.instance.refFromURL(imgUrl).delete();
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  //Comment method
  Future<bool> storeComment(String postId, String content) async {
    try {
      final user = await AuthMethod().getUserDetails();
      if (content.isEmpty) {
        return false;
      }
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
      return true;
    } catch (e) {
      print(e);
      rethrow;
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

  //User methods
  Future<String> followUser(String userId, String uid) async {
    try {
      final UserModel userUid = await getUserByUid(uid);
      if (userUid.followers.contains(userId)) {
        await _firestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayRemove([userId])
        });
        return "Unfollow successfully";
      } else {
        await _firestore.collection('users').doc(userId).update({
          'following': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'followers': FieldValue.arrayUnion([userId])
        });
        return "Follow successfully";
      }
    } catch (e) {
      print(e);
      return (e.toString());
    }
  }

  Future<UserModel> getUserByUid(String uid) async {
    try {
      final snap = await _firestore.collection('users').doc(uid).get();
      return UserModel.fromsnap(snap);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future searchUser(String text) async {
    try {
      final snap = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: text)
          .where('username', isLessThanOrEqualTo: text)
          .get();
      return snap;
    } catch (e) {
      print(e);
    }
  }

  //Message Methods
  Future<String> checkMessage(String userId, String uid) async {
    try {
      String uidMessageBox1 = "${userId}_$uid";
      String uidMessageBox2 = "${uid}_$userId";

      var box = await _firestore.collection("messageBox").where('messageBoxId',
          whereIn: [uidMessageBox1, uidMessageBox2]).get();

      if (box.docs.isEmpty) {
        MessageBox msBox = MessageBox(
          messageBoxId: uidMessageBox1,
          arrUid: [userId, uid],
          lastMessageTime: DateTime.now(),
          lastMessage: "",
          lastMessageBy: "",
        );
        await _firestore
            .collection('messageBox')
            .doc(uidMessageBox1)
            .set(msBox.toJson());
        return uidMessageBox1;
      } else {
        return box.docs[0]['messageBoxId'];
      }
    } catch (e) {
      print(e);
      return (e.toString());
    }
  }

  Future<void> storeMessage(
      String content, String messageBoxId, String fromUid) async {
    try {
      String messageId = const Uuid().v1();
      Message mes = Message(
        messageId: messageId,
        messageBoxId: messageBoxId,
        content: content,
        fromUid: fromUid,
        dateSend: DateTime.now(),
      );

      await _firestore.collection('message').doc(messageId).set(mes.toJson());

      await FirebaseFirestore.instance
          .collection('messageBox')
          .doc(messageBoxId)
          .update({
        'lastMessage': content,
        'lastMessageBy': fromUid,
        'lastMessageTime': DateTime.now()
      });
    } catch (e) {
      print(e);
    }
  }
}
