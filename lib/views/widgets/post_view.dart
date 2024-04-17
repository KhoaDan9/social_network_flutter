import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagramz_flutter/models/user.dart' as model;
import 'package:instagramz_flutter/providers/user_provider.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:instagramz_flutter/views/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostView extends StatefulWidget {
  final snap;
  const PostView({super.key, required this.snap});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.fromLTRB(5, 4, 0, 4).copyWith(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.snap['userPhotoUrl']),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.snap['username'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(widget.snap['description']),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () async {
                    await FireStoreMethod().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.27,
                          width: double.infinity,
                          child: Image.network(
                            widget.snap['postPhotoUrl'],
                          ),
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimationView(
                          isAnimating: isLikeAnimating,
                          duration: const Duration(milliseconds: 400),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 100,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          LikeAnimationView(
                            isAnimating:
                                widget.snap['likes'].contains(user.uid),
                            smallLike: true,
                            child: IconButton(
                              icon: widget.snap['likes'].contains(user.uid)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    )
                                  : const Icon(Icons.favorite_border),
                              onPressed: () async {
                                await FireStoreMethod().likePost(
                                  widget.snap['postId'],
                                  user.uid,
                                  widget.snap['likes'],
                                );
                              },
                            ),
                          ),
                          if (widget.snap['likes'].length != 0)
                            Text('${widget.snap['likes'].length}'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.comment_outlined),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.bookmark_border),
                        onPressed: () {},
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                  child: Text(
                    DateFormat.jm()
                        .add_yMMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
