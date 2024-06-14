import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramz_flutter/features/home/upload_post/bloc/upload_post_bloc.dart';
import 'package:instagramz_flutter/features/home/upload_post/bloc/upload_post_event.dart';
import 'package:instagramz_flutter/features/home/upload_post/bloc/upload_post_state.dart';
import 'package:instagramz_flutter/utilities/image_picker.dart';

class AddPostView extends StatefulWidget {
  const AddPostView({super.key});

  @override
  State<AddPostView> createState() => _AddPostViewState();
}

class _AddPostViewState extends State<AddPostView> {
  Uint8List? _image;
  late TextEditingController _textController;
  bool isLoading = false;

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

  selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await imagePicker(ImageSource.camera);
                  setState(() {
                    _image = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await imagePicker(ImageSource.gallery);
                  setState(() {
                    _image = file;
                  });
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadPostBloc, UploadPostState>(
      listener: (context, state) {
        if (state is UploadPostSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          FocusManager.instance.primaryFocus?.unfocus();
          setState(() {
            _image = null;
            _textController.text = "";
          });
        }
        if (state is UploadPostFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.exception),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Post'),
            actions: [
              TextButton(
                  onPressed: () {
                    context.read<UploadPostBloc>().add(UploadPostOnClickEvent(
                        description: _textController.text, file: _image));
                  },
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blue[300],
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state.isLoading) const LinearProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (_image != null)
                        IconButton(
                            onPressed: () => {
                                  setState(() {
                                    _image = null;
                                  })
                                },
                            icon: const Icon(Icons.disabled_by_default_sharp)),
                      if (_image != null)
                        Image.memory(
                          _image!,
                          width: 300,
                          height: 300,
                        ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "What is happening?",
                        ),
                        controller: _textController,
                        maxLines: null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: IconButton(
            onPressed: () => {
              selectImage(context),
            },
            icon: const Icon(Icons.photo_outlined),
          ),
        );
      },
    );
  }
}
