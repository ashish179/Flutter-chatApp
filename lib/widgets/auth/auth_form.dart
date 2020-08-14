import 'dart:io';

import '../pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitfn, this._isLoading);
  final bool _isLoading;
  final void Function(String email, String password, String username,
      File _image, bool isLogin, BuildContext ctx) submitfn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;

  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';
  File _image;
  void pickedImage(File image) {
    _image = image;
  }

  void _trySubmit() {
    final isValid = _form.currentState.validate();
    //to remove keyboard after submitting form
    FocusScope.of(context).unfocus();

    if (_image == null && !_isLogin) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error acuured'),
                content: Text('add image'),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('ok'))
                ],
              ));
      return;
    }
    if (isValid) {
      _form.currentState.save();
      widget.submitfn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _image, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin) UserImagePicker(pickedImage),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'please enter at least 4 character';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(labelText: 'username'),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'please enter valid e,mail addess';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email id'),
                      onSaved: (newValue) {
                        _userEmail = newValue;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 5) {
                          return 'password must be at least 6 character long';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(labelText: 'password'),
                      obscureText: true,
                      onSaved: (newValue) {
                        _userPassword = newValue;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget._isLoading) CircularProgressIndicator(),
                    if (!widget._isLoading)
                      RaisedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogin ? 'login' : 'Signup'),
                      ),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin
                              ? 'create new account'
                              : 'I already have account ?',
                        ))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
