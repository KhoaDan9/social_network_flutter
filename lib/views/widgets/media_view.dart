import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MediaView extends StatefulWidget {
  final String uid;
  const MediaView({super.key, required this.uid});

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  var _allPostsImg = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    var sort = [];
    var data = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .get();

    for (var post in data.docs) {
      if (post['uid'] == widget.uid && post['postPhotoUrl'] != '') {
        sort.add(post);
      }
    }
    setState(() {
      _allPostsImg = sort;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: _allPostsImg.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) => Container(
        child: Image.network(_allPostsImg[index]['postPhotoUrl']),
      ),
    );
  }
}
