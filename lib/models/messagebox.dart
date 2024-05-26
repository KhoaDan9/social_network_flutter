import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class MessageBox {
  final String messageBoxId;
  final String lastMessage;
  final String lastMessageBy;
  final DateTime lastMessageTime;
  final List arrUid;

  const MessageBox({
    required this.messageBoxId,
    required this.arrUid,
    required this.lastMessageBy,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toJson() => {
        "messageBoxId": messageBoxId,
        "arrUid": arrUid,
        "lastMessageBy": lastMessageBy,
        "lastMessage": lastMessage,
        "lastMessageTime": lastMessageTime,
      };

  static MessageBox fromsnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    Timestamp timestamp = snapshot['lastMessageTime'];

    return MessageBox(
      messageBoxId: snapshot['messageBoxId'],
      arrUid: snapshot['arrUid'],
      lastMessageBy: snapshot['lastMessageBy'],
      lastMessage: snapshot['lastMessage'],
      lastMessageTime: DateTime.parse(timestamp.toDate().toString()),
    );
  }
}
