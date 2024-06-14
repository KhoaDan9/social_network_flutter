import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramz_flutter/features/home/bloc/home_bloc.dart';
import 'package:instagramz_flutter/features/home/bloc/home_event.dart';
import 'package:instagramz_flutter/features/home/bloc/home_state.dart';
import 'package:instagramz_flutter/features/home/upload_post/upload_post_view.dart';
import 'package:instagramz_flutter/views/all_message_view.dart';
import 'package:instagramz_flutter/features/home/feed/feed_view.dart';
import 'package:instagramz_flutter/views/profile_view.dart';
import 'package:instagramz_flutter/views/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget getView(int index, BuildContext context) {
    switch (index) {
      case 0:
        return const FeedView();
      case 1:
        return const SearchView();
      case 2:
        return const AddPostView();
      case 3:
        return const AllMessageView();
      case 4:
        return ProfileView(uid: FirebaseAuth.instance.currentUser!.uid);
      default:
        return const FeedView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomePage) {
          return Scaffold(
            body: getView(state.pageIndex, context),
            bottomNavigationBar: CupertinoTabBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                    color: state.pageIndex == 0 ? Colors.white : Colors.grey,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                    color: state.pageIndex == 1 ? Colors.white : Colors.grey,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: state.pageIndex == 2 ? Colors.white : Colors.grey,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.comment,
                    color: state.pageIndex == 3 ? Colors.white : Colors.grey,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    color: state.pageIndex == 4 ? Colors.white : Colors.grey,
                  ),
                )
              ],
              onTap: (pageIndex) {
                context.read<HomeBloc>().add(PageTapped(pageIndex: pageIndex));
              },
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
