import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagramz_flutter/models/messagebox.dart';
import 'package:instagramz_flutter/models/user.dart';
import 'package:instagramz_flutter/views/message_view.dart';
import 'package:intl/intl.dart';

class MessageDetail extends StatefulWidget {
  final MessageBox msgBox;
  final String uid;
  const MessageDetail({
    required this.uid,
    required this.msgBox,
    super.key,
  });

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          FirebaseFirestore.instance.collection('users').doc(widget.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final User user = User.fromsnap(snapshot.data!);

        var msg = widget.msgBox.lastMessage;
        if (widget.msgBox.lastMessageBy != user.uid) {
          msg = "You: $msg";
        }
        return InkWell(
          onTap: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return MessageView(
                    user: user,
                    messageBoxId: widget.msgBox.messageBoxId,
                  );
                },
              ),
            );
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user.photoUrl),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 240,
                            child: Text(
                              msg,
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            DateFormat.Hm().format(
                              widget.msgBox.lastMessageTime,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
