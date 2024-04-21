import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramz_flutter/models/user.dart' as model;
import 'package:instagramz_flutter/providers/user_provider.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:instagramz_flutter/views/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentView extends StatefulWidget {
  final String postId;
  const CommentView({
    super.key,
    required this.postId,
  });

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('comments')
            .where('postId', isEqualTo: widget.postId)
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }

          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: const Text('Comments'),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await FireStoreMethod()
                          .storeComment(widget.postId, _textController.text);
                      _textController.text = '';
                    },
                    child: const Text(
                      'Reply',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
              body: GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: ((context, index) {
                          QueryDocumentSnapshot<Map<String, dynamic>> cmtData =
                              snapshot.data!.docs[index];

                          return Card(
                            color: Colors.blueGrey[600],
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          NetworkImage(cmtData['userPhotoUrl']),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cmtData['username'],
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          cmtData['content'],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          DateFormat.jm().add_yMMMMd().format(
                                              snapshot.data!
                                                  .docs[index]['datePublished']
                                                  .toDate()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      LikeAnimationView(
                                        isAnimating: snapshot
                                            .data!.docs[index]['likes']
                                            .contains(user.uid),
                                        smallLike: true,
                                        child: IconButton(
                                          icon: cmtData['likes']
                                                  .contains(user.uid)
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.favorite_border),
                                          onPressed: () async {
                                            await FireStoreMethod().likeComment(
                                              cmtData['commentId'],
                                              user.uid,
                                              cmtData['likes'],
                                            );
                                          },
                                        ),
                                      ),
                                      if (cmtData['likes'].length != 0)
                                        Text('${cmtData['likes'].length}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _textController,
                        focusNode: FocusNode(),
                        autofocus: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
