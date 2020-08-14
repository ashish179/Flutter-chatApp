import 'dart:html';

import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  final String _message;
  final bool _isMe;
  final String _username;
  File _image;
  MessageBubble(this._message, this._isMe, this._username, this._image);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Row(
        mainAxisAlignment:
            widget._isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 150,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: widget._isMe
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).accentColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft:
                      !widget._isMe ? Radius.circular(0) : Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: widget._isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget._username),
                Text(
                  widget._message,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(top: 0, left: 120, child: CircleAvatar()),
    ]);
  }
}
