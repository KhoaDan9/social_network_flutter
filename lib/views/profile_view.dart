import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagramz_flutter/models/post.dart';
import 'package:instagramz_flutter/models/user.dart' as model;
import 'package:instagramz_flutter/providers/user_provider.dart';
import 'package:instagramz_flutter/views/widgets/media_view.dart';
import 'package:instagramz_flutter/views/widgets/post_view.dart';
import 'package:instagramz_flutter/views/widgets/text_profile.dart';
import 'package:provider/provider.dart';

class ProfileView extends StatefulWidget {
  final String uid;
  const ProfileView({super.key, required this.uid});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: widget.uid)
            .orderBy(
              'datePublished',
              descending: true,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(user.photoUrl),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(user.fullname),
                            Text(user.username)
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextColumnProfile(
                                    num: snapshot.data!.docs.length.toString(),
                                    content: 'Posts',
                                  ),
                                  TextColumnProfile(
                                    num: user.followers.length.toString(),
                                    content: 'Followers',
                                  ),
                                  TextColumnProfile(
                                    num: user.following.length.toString(),
                                    content: 'Following',
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.transparent),
                                    ),
                                    child: const Text(
                                      'Edit profile',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.white70,
                      labelColor: Colors.white,
                      indicatorWeight: 1,
                      indicatorColor: Colors.white,
                      tabs: const [
                        Tab(
                          text: 'Post',
                        ),
                        Tab(
                          text: 'Media',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => PostView(
                            snap: snapshot.data!.docs[index],
                            scaffoldKey: _scaffoldKey,
                          ),
                        ),
                        MediaView(uid: user.uid),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
