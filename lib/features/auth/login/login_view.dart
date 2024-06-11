import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramz_flutter/features/auth/login/bloc/login_bloc.dart';
import 'package:instagramz_flutter/features/auth/login/bloc/login_event.dart';
import 'package:instagramz_flutter/features/auth/login/bloc/login_state.dart';
import 'package:instagramz_flutter/features/home/bloc/home_bloc.dart';
import 'package:instagramz_flutter/features/home/bloc/home_event.dart';
import 'package:instagramz_flutter/utilities/constants.dart';
import 'package:instagramz_flutter/views/home_view.dart';
import 'package:instagramz_flutter/features/auth/register/register_view.dart';

class LoginView extends StatefulWidget {
  final bool isLoading;
  const LoginView({super.key, this.isLoading = false});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email, _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _listen(LoginState state) {
    HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    if (state is LoginSuccess) {
      homeBloc.add(SetUser(user: state.user));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeView()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) => {_listen(state)},
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Stack(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage(logoImg2),
                    height: 64,
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
                  if (state is LoginFailure)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Email or password is incorrect!',
                        style: TextStyle(color: Colors.red),
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
                              context.read<LoginBloc>().add(
                                    LoginOnClickEvent(
                                      email: _email.text,
                                      password: _password.text,
                                    ),
                                  );
                            },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have a account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const RegisterView()));
                      },
                      child: const Text(
                        'Register here!',
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}
