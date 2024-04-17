import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Comment {
  final String postId;
  final String uid;
  final String content;
  final String username;
  final List likes;
  final DateTime datePublished;
  final String commentUrl;
  final String userPhotoUrl;

  const Comment({
    required this.postId,
    required this.uid,
    required this.content,
    required this.username,
    required this.likes,
    required this.datePublished,
    required this.commentUrl,
    required this.userPhotoUrl,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "content": content,
        "postId": postId,
        "uid": uid,
        "likes": likes,
        "datePublished": datePublished,
        "commentUrl": commentUrl,
        "userPhotoUrl": userPhotoUrl
      };

  static Comment fromsnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      content: snapshot['content'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
      commentUrl: snapshot['commentUrl'],
      userPhotoUrl: snapshot['userPhotoUrl'],
    );
  }
}
