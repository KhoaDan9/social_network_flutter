import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class PostModel {
  final String postId;
  final String uid;
  final String description;
  final String username;
  final List likes;
  final DateTime datePublished;
  final String postPhotoUrl;
  final String userPhotoUrl;

  const PostModel({
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

  static PostModel fromsnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    Timestamp timestamp = snapshot['datePublished'];
    return PostModel(
      postId: snapshot['postId'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      description: snapshot['description'],
      likes: snapshot['likes'],
      datePublished: DateTime.parse(timestamp.toDate().toString()),
      postPhotoUrl: snapshot['postPhotoUrl'],
      userPhotoUrl: snapshot['userPhotoUrl'],
    );
  }
}
