import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  _NewMessagesState createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  var _entredmessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();

    Firestore.instance.collection('chat').add({
      'text': _entredmessage,
      'CreatedAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      '_userImage': userData['_imageurl']
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'send message...'),
              onChanged: (value) {
                setState(() {
                  _entredmessage = value;
                });
              },
            )),
            IconButton(
                icon: Icon(Icons.send),
                onPressed: _entredmessage.trim().isEmpty ? null : _sendMessage)
          ],
        ));
  }
}
