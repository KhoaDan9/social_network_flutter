import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:instagramz_flutter/models/message.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:intl/intl.dart';
import 'package:instagramz_flutter/models/user_model.dart';

class MessageView extends StatefulWidget {
  final UserModel user;
  final String messageBoxId;
  const MessageView({
    super.key,
    required this.user,
    required this.messageBoxId,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late TextEditingController _textController;
  bool isButtonDisabled = true;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                widget.user.photoUrl,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              widget.user.username,
              style: const TextStyle(fontSize: 22),
            )
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FireStoreMethod()
                      .getStreamMessageByMessageBox(widget.messageBoxId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    } else {
                      final messages = snapshot.data!.docs
                          .map((e) => Message.fromsnap(e))
                          .toList();

                      return GroupedListView<Message, DateTime>(
                        reverse: true,
                        controller: _scrollController,
                        elements: messages,
                        order: GroupedListOrder.DESC,
                        // useStickyGroupSeparators: true,
                        // floatingHeader: true,
                        groupBy: (Message element) => DateTime(
                          element.dateSend.year,
                          element.dateSend.month,
                          element.dateSend.day,
                        ),
                        groupComparator: (DateTime value1, DateTime value2) =>
                            value1.compareTo(value2),
                        itemComparator: (message1, message2) =>
                            message1.dateSend.compareTo(message2.dateSend),
                        groupHeaderBuilder: (message) => SizedBox(
                          child: Center(
                            child: Card(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  DateFormat.yMMMMd().format(
                                    message.dateSend,
                                  ),
                                  style: TextStyle(color: Colors.grey[400]),
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (context, message) => Align(
                          alignment: message.fromUid == widget.user.uid
                              ? Alignment.bottomLeft
                              : Alignment.bottomRight,
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  message.fromUid == widget.user.uid
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.end,
                              children: [
                                Card(
                                  elevation: 4,
                                  color: message.fromUid == widget.user.uid
                                      ? Colors.transparent
                                      : Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Text(
                                      message.content,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: Text(
                                    DateFormat.Hm().format(
                                      message.dateSend,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller: _textController,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                        maxLines: null,
                        onChanged: (value) {
                          if (value != '') {
                            setState(() {
                              isButtonDisabled = false;
                            });
                          } else {
                            setState(() {
                              isButtonDisabled = true;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Type your message here...',
                          hintStyle: const TextStyle(
                            color: Colors.black54,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                              color: Colors.blue,
                              width: 2.0,
                            ),
                          ),
                          fillColor: Colors.grey.shade300,
                          filled: true,
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: isButtonDisabled
                        ? null
                        : () async {
                            await FireStoreMethod().storeMessage(
                                _textController.text,
                                widget.messageBoxId,
                                FirebaseAuth.instance.currentUser!.uid);
                            _textController.text = '';
                            _scrollController.animateTo(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                    icon: Icon(
                      Icons.send,
                      color: isButtonDisabled
                          ? Colors.grey[400]
                          : Colors.blue[600],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
