import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramz_flutter/features/auth/register/bloc/register_bloc.dart';
import 'package:instagramz_flutter/features/auth/register/bloc/register_event.dart';
import 'package:instagramz_flutter/features/auth/register/bloc/register_state.dart';
import 'package:instagramz_flutter/utilities/constants.dart';
import 'package:instagramz_flutter/utilities/dialogs/register_success_dialog.dart';
import 'package:instagramz_flutter/utilities/image_picker.dart';
import 'package:instagramz_flutter/features/auth/login/login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email, _password, _fullname, _username;
  Uint8List? _image;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _fullname = TextEditingController();
    _username = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) async {
              if (state is RegisterSuccess) {
                await showRegisterSuccessDialog(
                    context, 'Register successfully!');
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Image(
                      image: AssetImage(logoImg2),
                      height: 64,
                    ),
                  ),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage: MemoryImage(_image!),
                            )
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://w1.pngwing.com/pngs/743/500/png-transparent-circle-silhouette-logo-user-user-profile-green-facial-expression-nose-cartoon-thumbnail.png'),
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
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _fullname,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Fullname',
                    ),
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
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (state is RegisterFailure)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        state.exception,
                        style: const TextStyle(color: Colors.red),
                      ),
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
                      onPressed: state.isLoading
                          ? null
                          : () async {
                              // await AuthMethod().registerUser(
                              // email: _email.text,
                              // fullname: _fullname.text,
                              // username: _username.text,
                              // password: _password.text,
                              // image: _image!,
                              // );
                              _image ??= Uint8List.fromList([1, 2, 3, 4, 5]);
                              context.read<RegisterBloc>().add(
                                    RegisterOnClickEvent(
                                      email: _email.text,
                                      fullname: _fullname.text,
                                      username: _username.text,
                                      password: _password.text,
                                      image: _image!,
                                    ),
                                  );
                            },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have a account?"),
                      TextButton(
                        onPressed: () {
                          context
                              .read<RegisterBloc>()
                              .add(const RefreshRegisterEvent());
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginView()));
                        },
                        child: const Text(
                          'Login here!',
                        ),
                      )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
