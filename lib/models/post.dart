import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Post {
  final String postId;
  final String uid;
  final String description;
  final String username;
  final List likes;
  final DateTime datePublished;
  final String postPhotoUrl;
  final String userPhotoUrl;

  const Post({
    required this.postId,
    required this.uid,
    required this.description,
    required this.username,
    required this.likes,
    required this.datePublished,
    required this.postPhotoUrl,
    required this.userPhotoUrl,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "description": description,
        "postId": postId,
        "uid": uid,
        "likes": likes,
        "datePublished": datePublished,
        "postPhotoUrl": postPhotoUrl,
        "userPhotoUrl": userPhotoUrl
      };

  static Post fromsnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      description: snapshot['description'],
      likes: snapshot['likes'],
      datePublished: snapshot['datePublished'],
      postPhotoUrl: snapshot['postPhotoUrl'],
      userPhotoUrl: snapshot['userPhotoUrl'],
    );
  }
}
