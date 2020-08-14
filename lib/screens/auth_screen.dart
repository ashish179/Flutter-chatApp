import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  var _isLoading = false;
  void _submitAuthForm(String email, String password, String username,
      File _image, bool isLogin, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('_image')
            .child(authResult.user.uid + '.jpg');
        await ref.putFile(_image).onComplete;
        final url = await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({'username': username, 'email': email, '_imageurl': url});
      }
    } on PlatformException catch (error) {
      var message = 'an error accured, plase chack your credentials';
      if (error.message != null) {
        message = error.message;
      }
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error acuured'),
                content: Text(message),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('ok'))
                ],
              ));
      //   Scaffold.of(ctx).showSnackBar(SnackBar(
      //    content: Text(message),
      //    backgroundColor: Theme.of(ctx).errorColor,
      // ));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isLoading));
  }
}
