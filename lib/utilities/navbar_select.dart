import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramz_flutter/views/add_post_view.dart';
import 'package:instagramz_flutter/views/feed_view.dart';
import 'package:instagramz_flutter/views/profile_view.dart';

final user = FirebaseAuth.instance.currentUser;

List<Widget> navbarSelection = [
  const FeedView(),
  const Text('Search'),
  const AddPostView(),
  const Text('Favorites'),
  ProfileView(uid: user!.uid)
];
