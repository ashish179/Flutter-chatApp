import './message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futuresnapshot) {
          if (futuresnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder(
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy('CreatedAt', descending: true)
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final documents = snapshot.data.documents;
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (ctx, index) => MessageBubble(
                      documents[index]['text'],
                      documents[index]['userId'] == futuresnapshot.data.uid,
                      documents[index]['Username'],
                      documents[index]['_imageurl']),
                  itemCount: documents.length,
                );
              });
        });
  }
}
