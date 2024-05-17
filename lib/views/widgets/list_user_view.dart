import 'package:flutter/material.dart';
import 'package:instagramz_flutter/views/profile_view.dart';

class ListUserView extends StatefulWidget {
  final userData;
  const ListUserView({super.key, required this.userData});

  @override
  State<ListUserView> createState() => _ListUserViewState();
}

class _ListUserViewState extends State<ListUserView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Card(
        color: Colors.white10,
        child: ListTile(
          minVerticalPadding: 20,
          leading: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.userData['photoUrl']),
          ),
          title: Text(widget.userData['username']),
          subtitle: Text(widget.userData['fullname']),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white60, width: 1),
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) =>
                    ProfileView(uid: widget.userData['uid'])),
              ),
            );
          },
        ),
      ),
    );
  }
}
