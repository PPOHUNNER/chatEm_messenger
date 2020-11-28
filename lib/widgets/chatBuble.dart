import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ChatBubble extends StatefulWidget {
  final String content;
  final String username;
  final String userID;
  ChatBubble(this.content,this.username,this.userID);
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final authInstance = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          crossAxisAlignment: widget.userID == authInstance.currentUser.uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(widget.username),
            Text(widget.content),
          ],
        ),
      ),
    );
  }
}
