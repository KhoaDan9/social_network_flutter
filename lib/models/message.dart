import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

@immutable
class Message {
  final String messageId;
  final String messageBoxId;
  final String fromUid;
  final String content;
  final DateTime dateSend;

  const Message({
    required this.messageId,
    required this.messageBoxId,
    required this.content,
    required this.fromUid,
    required this.dateSend,
  });

  Map<String, dynamic> toJson() => {
        "messageId": messageId,
        "messageBoxId": messageBoxId,
        "content": content,
        "fromUid": fromUid,
        "dateSend": dateSend
      };

  static Message fromsnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    Timestamp timestamp = snapshot['dateSend'];
    return Message(
      messageId: snapshot['messageId'],
      messageBoxId: snapshot['messageBoxId'],
      content: snapshot['content'],
      fromUid: snapshot['fromUid'],
      dateSend: DateTime.parse(timestamp.toDate().toString()),
    );
  }
}
