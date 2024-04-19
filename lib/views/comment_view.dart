import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';

class CommentView extends StatefulWidget {
  final String postId;
  const CommentView({
    super.key,
    required this.postId,
  });

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  late TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Comments'),
        actions: [
          TextButton(
            onPressed: () async {
              await FireStoreMethod()
                  .storeComment(widget.postId, _textController.text);
            },
            child: const Text(
              'Reply',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Stack(
            // fit: StackFit.expand,
            children: [
              const ListTile(),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextField(
                  controller: _textController,
                  focusNode: FocusNode(),
                  autofocus: true,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
