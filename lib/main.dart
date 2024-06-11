import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramz_flutter/features/auth/login/bloc/login_bloc.dart';
import 'package:instagramz_flutter/features/auth/register/bloc/register_bloc.dart';
import 'package:instagramz_flutter/features/home/bloc/home_bloc.dart';
import 'package:instagramz_flutter/firebase_options.dart';
import 'package:instagramz_flutter/providers/user_provider.dart';
import 'package:instagramz_flutter/resources/auth_method.dart';
import 'package:instagramz_flutter/features/auth/login/login_view.dart';
import 'package:instagramz_flutter/resources/firestore_method.dart';
import 'package:instagramz_flutter/features/auth/register/register_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginBloc(authMethod: AuthMethod())),
        BlocProvider(
            create: (context) => HomeBloc(fireStoreMethod: FireStoreMethod())),
        BlocProvider(
            create: (context) => RegisterBloc(authMethod: AuthMethod()))
      ],
      child: MaterialApp(
        title: 'Social network Rata',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const LoginView(),
      ),
    ),
  );
}
