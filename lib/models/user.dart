import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class User {
  final String username;
  final String uid;
  final String email;
  final String fullname;
  final List followers;
  final List following;
  final String photoUrl;
  final String bio;

  String get getUsername {
    return username;
  }

  const User(
      {required this.username,
      required this.uid,
      required this.email,
      required this.fullname,
      required this.followers,
      required this.following,
      required this.photoUrl,
      required this.bio});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "fullname": fullname,
        "followers": followers,
        "following": following,
        "photoUrl": photoUrl,
        "bio": bio,
      };

  static User fromsnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      fullname: snapshot['fullname'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
    );
  }
}
