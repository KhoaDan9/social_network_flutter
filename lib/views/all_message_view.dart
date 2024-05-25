import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllMessageView extends StatefulWidget {
  const AllMessageView({super.key});

  @override
  State<AllMessageView> createState() => _AllMessageViewState();
}

class _AllMessageViewState extends State<AllMessageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
      ),
      body: const Text('Message'),
    );
  }
}
