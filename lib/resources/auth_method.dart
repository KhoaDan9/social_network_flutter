import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagramz_flutter/resources/storage_method.dart';
import 'package:instagramz_flutter/models/user.dart' as model;

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromsnap(snapshot);
  }

  Future<void> registerUser({
    required String email,
    required String fullname,
    required String username,
    required String password,
    required Uint8List image,
  }) async {
    try {
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', image, false);

      model.User user = model.User(
          username: username,
          email: email,
          uid: cred.user!.uid,
          fullname: fullname,
          followers: const [],
          following: const [],
          photoUrl: photoUrl,
          bio: '');

      await _firestore.collection('users').doc(cred.user!.uid).set(
            user.toJson(),
          );
    } on FirebaseException catch (e) {
      if (e.code == 'invalid-email') {
        print('Please input your email');
      }
      if (e.code == 'weak-password') {
        print('Password should be at least 6 characters');
      }
      print('Auth error');
      print(e);
    } catch (e) {
      print('error');
      print(e);
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('Dang nhap thanh cong!');
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e);
        print(e.code);
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> editProfile(
      model.User user, String username, String bio, Uint8List? img) async {
    if (img != null) {
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', img, false);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'username': username, 'bio': bio, 'photoUrl': photoUrl});
      await FirebaseStorage.instance.refFromURL(user.photoUrl).delete();
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'username': username, 'bio': bio});
    }
  }
}
