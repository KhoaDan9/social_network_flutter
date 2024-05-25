import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class MessageBox {
  final String messageBoxId;
  final String userId;
  final String lastMessage;
  final DateTime datePublished;
  final String lastMessageTime;

  const MessageBox({
    required this.messageBoxId,
    required this.userId,
    required this.datePublished,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  Map<String, dynamic> toJson() => {
        "messageBoxId": messageBoxId,
        "userId": userId,
        "datePublished": datePublished,
        "lastMessage": lastMessage,
        "lastMessageTime": lastMessageTime,
      };

  static MessageBox fromsnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return MessageBox(
      messageBoxId: snapshot['messageBoxId'],
      userId: snapshot['userId'],
      datePublished: snapshot['datePublished'],
      lastMessage: snapshot['lastMessage'],
      lastMessageTime: snapshot['lastMessageTime'],
    );
  }
}
