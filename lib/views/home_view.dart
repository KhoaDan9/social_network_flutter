import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramz_flutter/providers/user_provider.dart';
import 'package:instagramz_flutter/views/add_post_view.dart';
import 'package:instagramz_flutter/views/feed_view.dart';
import 'package:instagramz_flutter/views/message_view.dart';
import 'package:instagramz_flutter/views/profile_view.dart';
import 'package:instagramz_flutter/views/search_view.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isLoading = true;
  int _page = 0;
  late PageController pageController;
  List<Widget> navbarSelection = [
    const FeedView(),
    const SearchView(),
    const AddPostView(),
    const Text('123'),
    ProfileView(uid: FirebaseAuth.instance.currentUser!.uid)
  ];

  @override
  void initState() {
    addData();
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {});
    await userProvider.refreshUser();
    setState(() {
      isLoading = false;
    });
  }

  void navigatorOnClick(int page) {
    setState(() {
      _page = page;
    });
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: navbarSelection,
            ),
            bottomNavigationBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: _page == 0 ? Colors.white : Colors.grey,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: _page == 1 ? Colors.white : Colors.grey,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: _page == 2 ? Colors.white : Colors.grey,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.favorite,
                    color: _page == 3 ? Colors.white : Colors.grey,
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: _page == 4 ? Colors.white : Colors.grey,
                  ),
                  label: '',
                )
              ],
              onTap: navigatorOnClick,
            ),
          );
  }
}
