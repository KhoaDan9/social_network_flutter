import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramz_flutter/models/messagebox.dart';
import 'package:instagramz_flutter/views/widgets/message_detail.dart';

class AllMessageView extends StatefulWidget {
  const AllMessageView({super.key});

  @override
  State<AllMessageView> createState() => _AllMessageViewState();
}

class _AllMessageViewState extends State<AllMessageView> {
  @override
  Widget build(BuildContext context) {
    String currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("messageBox")
            .where("arrUid", arrayContains: currentUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('chua thay j');
          }

          final List<MessageBox> messagesBox =
              snapshot.data!.docs.map((e) => MessageBox.fromsnap(e)).toList();
          return ListView.builder(
            itemCount: messagesBox.length,
            itemBuilder: (context, index) {
              String uid = '';
              for (String id in messagesBox[index].arrUid) {
                if (id != currentUid) {
                  uid = id;
                }
              }
              return MessageDetail(
                uid: uid,
                msgBox: messagesBox[index],
              );
            },
          );
        },
      ),
    );
  }
}
