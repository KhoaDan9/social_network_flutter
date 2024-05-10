import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagramz_flutter/models/user.dart' as model;
import 'package:instagramz_flutter/providers/user_provider.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:instagramz_flutter/views/comment_view.dart';
import 'package:instagramz_flutter/views/profile_view.dart';
import 'package:instagramz_flutter/views/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostView extends StatefulWidget {
  final snap;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const PostView({super.key, required this.snap, required this.scaffoldKey});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  bool isLikeAnimating = false;
  int cmtNum = 0;

  void getCmtNum() async {
    int num = await FireStoreMethod().getCommentNum(widget.snap['postId']);
    setState(() {
      cmtNum = num;
    });
  }

  @override
  void initState() {
    super.initState();
    getCmtNum();
  }

  viewProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ProfileView(
            uid: widget.snap['uid'],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    UserProvider userProvider = Provider.of(context, listen: false);
    String textFollow;
    if (!user.following.contains(widget.snap['uid'])) {
      textFollow = 'Follow';
    } else {
      textFollow = 'Unfollow';
    }
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 4, 0, 4).copyWith(),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(width: 2, color: Colors.grey[850]!),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: GestureDetector(
              onTap: () => viewProfile(context),
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.snap['userPhotoUrl']),
              ),
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
                            GestureDetector(
                              onTap: () => viewProfile(context),
                              child: Text(
                                widget.snap['username'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // InkWell(
                                  //   onTap: () {},
                                  //   borderRadius: const BorderRadius.vertical(
                                  //       top: Radius.circular(20)),
                                  //   child: Container(
                                  //     padding: const EdgeInsets.fromLTRB(
                                  //         10, 10, 0, 5),
                                  //     child: const Row(
                                  //       children: [
                                  //         Icon(
                                  //           Icons.edit_outlined,
                                  //           size: 22,
                                  //         ),
                                  //         SizedBox(
                                  //           width: 10,
                                  //         ),
                                  //         Text(
                                  //           'Edit post',
                                  //           style: TextStyle(fontSize: 22),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),

                                  if (user.uid != widget.snap['uid'])
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await FireStoreMethod().followUser(
                                            user.uid,
                                            widget.snap['uid'],
                                            user.following);

                                        ScaffoldMessenger.of(widget
                                                .scaffoldKey.currentContext!)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                '$textFollow successfully'),
                                          ),
                                        );
                                        await userProvider.refreshUser();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: Row(
                                          children: [
                                            if (!user.following
                                                .contains(widget.snap['uid']))
                                              const Icon(
                                                Icons.person_add_alt,
                                                size: 22,
                                              )
                                            else
                                              const Icon(
                                                Icons
                                                    .person_remove_alt_1_outlined,
                                                size: 22,
                                              ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    fontSize: 22),
                                                children: [
                                                  TextSpan(
                                                      text: '$textFollow '),
                                                  TextSpan(
                                                    text:
                                                        '@${widget.snap['username']}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    InkWell(
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await FireStoreMethod().deletePost(
                                            widget.snap['postId'],
                                            widget.snap['postPhotoUrl']);
                                        ScaffoldMessenger.of(widget
                                                .scaffoldKey.currentContext!)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Delete post successfully'),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.delete_outline,
                                              size: 22,
                                              color: Colors.red,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Delete post',
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (widget.snap['postPhotoUrl'] != '')
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
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.comment_outlined),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return CommentView(
                                      postId: widget.snap['postId'],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          if (cmtNum > 0) Text(cmtNum.toString())
                        ],
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
