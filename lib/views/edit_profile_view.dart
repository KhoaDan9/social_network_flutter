import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramz_flutter/features/home/bloc/home_bloc.dart';
import 'package:instagramz_flutter/features/home/bloc/home_event.dart';
import 'package:instagramz_flutter/models/user_model.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:instagramz_flutter/utilities/image_picker.dart';

class EditProfileView extends StatefulWidget {
  final UserModel user;

  const EditProfileView({super.key, required this.user});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _email, _bio, _fullname, _username;
  Uint8List? _image;

  @override
  void initState() {
    super.initState();

    _email = TextEditingController();
    _bio = TextEditingController();
    _fullname = TextEditingController();
    _username = TextEditingController();

    _email.text = widget.user.email;
    _fullname.text = widget.user.fullname;
    _bio.text = widget.user.bio;
    _username.text = widget.user.username;
  }

  @override
  void dispose() {
    _email.dispose();
    _bio.dispose();
    _fullname.dispose();
    _username.dispose();

    super.dispose();
  }

  void selectImage() async {
    Uint8List img = await imagePicker(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(widget.user.photoUrl),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _email,
                    style: const TextStyle(color: Colors.white54),
                    enableInteractiveSelection: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _fullname,
                    style: const TextStyle(color: Colors.white54),
                    enableInteractiveSelection: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fullname',
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _bio,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Bio',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: Colors.blue[300],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                      ),
                      onPressed: () async {
                        await AuthMethod().editProfile(
                            widget.user, _username.text, _bio.text, _image);
                        final UserModel userUpdate = await FireStoreMethod()
                            .getUserByUid(widget.user.uid);
                        HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
                        homeBloc.add(SetUser(user: userUpdate));
                        homeBloc.add(const PageTapped(
                          pageIndex: 4,
                        ));
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Save changes',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
