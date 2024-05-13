import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagramz_flutter/models/user.dart' as model;
import 'package:instagramz_flutter/providers/user_provider.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:instagramz_flutter/views/edit_profile_view.dart';
import 'package:instagramz_flutter/views/login_view.dart';
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
  // var data = {};
  bool isFollowing = false;
  var userAuth = FirebaseAuth.instance.currentUser!;
  // var isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // getData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: widget.uid)
            .snapshots(),
        builder: (context, snapshot2) {
          if (snapshot2.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              actions: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Logout',
                      child: Text('Logout'),
                    )
                  ],
                  onSelected: (value) {
                    if (value == 'Logout') {
                      AuthMethod().logout();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginView()));
                    }
                  },
                ),
              ],
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
                  return const Center(child: CircularProgressIndicator());
                }

                return SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                        snapshot2.data!.docs[0]['photoUrl']),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snapshot2.data!.docs[0]['username'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  Text(snapshot2.data!.docs[0]['fullname']),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextColumnProfile(
                                          num: snapshot.data!.docs.length
                                              .toString(),
                                          content: 'Posts',
                                        ),
                                        TextColumnProfile(
                                          num: snapshot2
                                              .data!.docs[0]["followers"].length
                                              .toString(),
                                          content: 'Followers',
                                        ),
                                        TextColumnProfile(
                                          num: snapshot2
                                              .data!.docs[0]["following"].length
                                              .toString(),
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
                                        child: snapshot2.data!.docs[0]['uid'] ==
                                                user.uid
                                            ? OutlinedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                      return EditProfileView(
                                                        user: user,
                                                      );
                                                    }),
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                ),
                                                child: const Text(
                                                  'Edit profile',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : OutlinedButton(
                                                onPressed: () async {
                                                  FireStoreMethod().followUser(
                                                      user.uid,
                                                      snapshot2.data!.docs[0]
                                                          ["uid"],
                                                      user.following);
                                                  if (!context.mounted) return;
                                                  Provider.of<UserProvider>(
                                                          context,
                                                          listen: false)
                                                      .refreshUser();
                                                },
                                                style: snapshot2.data!
                                                        .docs[0]["followers"]
                                                        .contains(user.uid)
                                                    ? ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .black),
                                                      )
                                                    : ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .white),
                                                      ),
                                                child: snapshot2.data!
                                                        .docs[0]["followers"]
                                                        .contains(user.uid)
                                                    ? const Text(
                                                        'Unfollow',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : const Text(
                                                        'Follow',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
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
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            snapshot2.data!.docs[0]['bio'],
                            style: const TextStyle(fontSize: 16),
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
                              MediaView(uid: snapshot2.data!.docs[0]["uid"]),
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
        });
  }
}
