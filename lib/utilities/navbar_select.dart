import 'package:flutter/material.dart';
import 'package:instagramz_flutter/views/add_post_view.dart';
import 'package:instagramz_flutter/views/feed_view.dart';

List<Widget> navbarSelection = [
  const FeedView(),
  const Text('Search'),
  const AddPostView(),
  const Text('Favorites'),
  const Text('Profile'),
];
