import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatBubble extends StatefulWidget {
  final String content;
  final String username;
  final String userID;
  final String userImage;
  ChatBubble(this.content, this.username, this.userID,this.userImage);
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final authInstance = FirebaseAuth.instance;
  String currentUID = FirebaseAuth.instance.currentUser.uid;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: currentUID == widget.userID
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(13),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 15),
              decoration: BoxDecoration(
                color: currentUID == widget.userID
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: currentUID == widget.userID
                        ? Radius.circular(20)
                        : Radius.circular(0),
                    bottomRight: currentUID == widget.userID
                        ? Radius.circular(0)
                        : Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Text(
                    "${widget.username}:",
                    textAlign: currentUID == widget.userID
                        ? TextAlign.end
                        : TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.content,
                    textAlign: currentUID == widget.userID
                        ? TextAlign.end
                        : TextAlign.start,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
