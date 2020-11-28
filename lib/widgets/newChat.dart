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
            controller: _newChatController,
            decoration: InputDecoration(labelText: "Type a new message"),
          )),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
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
            },
          )
        ],
      ),
    );
  }

  void sendMessage(Map<String, dynamic> newMsg) async {
    final String docID1 =
        authInstance.currentUser.uid + widget.recieverData['uid'];
    final String docID2 =
        widget.recieverData['uid'] + authInstance.currentUser.uid;

    firestore.collection('messages').doc(docID1).get().then((value) {
      if (value.exists) {
        validDoc = docID1;
      }
    });
    firestore.collection('messages').doc(docID2).get().then((value) {
      if (value.exists) {
        validDoc = docID2;
      }
    });
    print(validDoc);
    if (validDoc == null) {
      validDoc = docID1;
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
  }
}
