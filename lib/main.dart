import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramz_flutter/firebase_options.dart';
import 'package:instagramz_flutter/providers/user_provider.dart';
import 'package:instagramz_flutter/views/login_view.dart';
import 'package:instagramz_flutter/views/register_view.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
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
