import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramz_flutter/features/home/feed/bloc/feed_bloc.dart';
import 'package:instagramz_flutter/features/home/feed/bloc/feed_event.dart';
import 'package:instagramz_flutter/features/home/feed/bloc/feed_state.dart';
import 'package:instagramz_flutter/models/post_model.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:instagramz_flutter/utilities/constants.dart';
import 'package:instagramz_flutter/views/widgets/post_view.dart';

class FeedView extends StatefulWidget {
  final String? uid;
  const FeedView({super.key, this.uid});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state is FollowSuccess || state is DeletePostSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
            ),
          );
          context.read<FeedBloc>().add(const ChangeFeedState());
        }
      },
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: (state is ProfilePostsState)
              ? null
              : AppBar(
                  title: Image(
                    image: AssetImage(logoImg2),
                    height: 64,
                  ),
                  titleSpacing: 0,
                  centerTitle: false,
                  actions: [
                    IconButton(
                      onPressed: () async {},
                      icon: const Icon(Icons.chat_bubble_outline),
                    )
                  ],
                ),
          body: StreamBuilder(
            stream: (state is ProfilePostsState)
                ? FireStoreMethod().getStreamProfilePosts(widget.uid!)
                : FireStoreMethod().getStreamAllPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: CircularProgressIndicator(),
                );
              }
              final List<PostModel> posts = snapshot.data!.docs
                  .map((doc) => PostModel.fromsnap(doc))
                  .toList();
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) =>
                    PostView(post: posts[index], scaffoldKey: _scaffoldKey),
              );
            },
          ),
        );
      },
    );
  }
}
