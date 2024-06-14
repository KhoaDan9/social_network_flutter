import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagramz_flutter/views/widgets/list_user_view.dart';
import 'package:instagramz_flutter/views/widgets/post_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late final TextEditingController _searchController;
  late final TabController _tabController;
  var _allUser = [];
  var _searchResult = [];
  var _allPosts = [];
  var _searchPostsResult = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChange);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onSearchChange);
    _searchController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
  }

  void getData() async {
    var data = await FirebaseFirestore.instance.collection('users').get();
    var posts = await FirebaseFirestore.instance
        .collection('posts')
        .orderBy('datePublished', descending: true)
        .get();
    setState(() {
      _allUser = data.docs;
      _allPosts = posts.docs;
    });
    searchResultList();
  }

  _onSearchChange() {
    searchResultList();
  }

  searchResultList() {
    var result = [];
    var postsResult = [];

    if (_searchController.text != "") {
      for (var user in _allUser) {
        if (user['fullname']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            user['username']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase())) {
          result.add(user);
        }
      }
      for (var post in _allPosts) {
        if (post['description']
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          postsResult.add(post);
        }
      }
    } else {
      result = _allUser;
    }
    setState(() {
      _searchResult = result;
      _searchPostsResult = postsResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onSubmitted: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                hintText: 'Find something...',
                filled: true,
                fillColor: Colors.white12,
                contentPadding:
                    const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(25.7),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white12),
                  borderRadius: BorderRadius.circular(25.7),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.white70,
              labelColor: Colors.white,
              indicatorWeight: 1,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(
                  text: 'Users',
                ),
                Tab(
                  text: 'Posts',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ListView.builder(
                    itemCount: _searchResult.length,
                    itemBuilder: (context, index) {
                      return ListUserView(
                        userData: _searchResult[index],
                      );
                    },
                  ),
                  ListView.builder(
                    itemCount: _searchPostsResult.length,
                    itemBuilder: (context, index) {
                      return PostView(
                        post: _searchPostsResult[index],
                        scaffoldKey: _scaffoldKey,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
