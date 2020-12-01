import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewChat extends StatefulWidget {
  final Map<String, dynamic> recieverData;
  NewChat(this.recieverData);
  @override
  _NewChatState createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  String validDoc;
  bool isSent = true;
  final authInstance = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  TextEditingController _newChatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Expanded(
              child: TextField(
                maxLines: 2,
                textInputAction: TextInputAction.newline,
            controller: _newChatController,
            decoration: InputDecoration(labelText: "Type a new message",),
          )),
          isSent
              ? IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    setState(() {
                      isSent = false;
                      });
                    String user;
                    final daata = await firestore
                        .collection('users')
                        .doc(authInstance.currentUser.uid)
                        .get();
                    user = daata['username'];
                    Map<String, dynamic> data = {
                      'userid': authInstance.currentUser.uid,
                      'reciever': widget.recieverData['username'],
                      'msgType': 'text',
                      'content': _newChatController.text,
                      'createdAt': Timestamp.now(),
                      'sender': user
                    };
                    sendMessage(data);
                    _newChatController.clear();
                  },
                )
              : CircularProgressIndicator()
        ],
      ),
    );
  }

  void sendMessage(Map<String, dynamic> newMsg) async {
    final String docID1 =
        authInstance.currentUser.uid + widget.recieverData['uid'];
    final String docID2 =
        widget.recieverData['uid'] + authInstance.currentUser.uid;

    DocumentSnapshot doc1 =
        await firestore.collection('messages').doc(docID1).get();
    if (doc1.exists) {
      setState(() {
        validDoc = docID1;
      });
    }
    doc1 = await firestore.collection('messages').doc(docID2).get();
    if (doc1.exists) {
      setState(() {
        validDoc = docID2;
      });
    }
    if (validDoc == null) {
      setState(() {
        validDoc = docID1;
      });
    }
    
    final msgRef = await firestore
        .collection('messages')
        .doc(validDoc)
        .collection('chats')
        .add(newMsg);
    final docRef = await firestore
        .collection('messages')
        .doc(validDoc)
        .set({'chat': true});
    setState(() {
      isSent = true;
    });
  }
}
