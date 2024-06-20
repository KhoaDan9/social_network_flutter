import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramz_flutter/features/home/bloc/home_bloc.dart';
import 'package:instagramz_flutter/models/comment.dart';
import 'package:instagramz_flutter/models/user_model.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:instagramz_flutter/views/widgets/like_animation.dart';
import 'package:intl/intl.dart';

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
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    UserModel user = homeBloc.state.user!;

    return StreamBuilder(
        stream: FireStoreMethod().getCommentByPostId(widget.postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: CircularProgressIndicator(),
            );
          }
          List<Comment> comments =
              snapshot.data!.docs.map((e) => Comment.fromsnap(e)).toList();
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
                      final isSuccess = await FireStoreMethod()
                          .storeComment(widget.postId, _textController.text);
                      _textController.text = '';
                      if (isSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Comment successfully!"),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please input something!"),
                          ),
                        );
                      }
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
                        itemCount: comments.length,
                        itemBuilder: ((context, index) {
                          Comment cmtData = comments[index];
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
                                          NetworkImage(cmtData.userPhotoUrl),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cmtData.username,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          cmtData.content,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          DateFormat.jm()
                                              .add_yMMMMd()
                                              .format(cmtData.datePublished),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w300),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      LikeAnimationView(
                                        isAnimating:
                                            cmtData.likes.contains(user.uid),
                                        smallLike: true,
                                        child: IconButton(
                                          icon: cmtData.likes.contains(user.uid)
                                              ? const Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.favorite_border),
                                          onPressed: () async {
                                            await FireStoreMethod().likeComment(
                                              cmtData.commentId,
                                              user.uid,
                                              cmtData.likes,
                                            );
                                          },
                                        ),
                                      ),
                                      if (cmtData.likes.isNotEmpty)
                                        Text('${cmtData.likes.length}'),
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
