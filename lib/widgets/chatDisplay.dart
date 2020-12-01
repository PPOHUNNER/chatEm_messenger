import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/chatBuble.dart';

class ChatDisplay extends StatefulWidget {
  final Map<String, dynamic> userData;
  ChatDisplay(this.userData);
  @override
  _ChatDisplayState createState() => _ChatDisplayState();
}

class _ChatDisplayState extends State<ChatDisplay> {
  final authInstance = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  String validDoc;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: idGenerator(),
        builder: (context, snap) {
          print("within the future builder");
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return StreamBuilder(
              stream: firestore
                  .collection('messages')
                  .doc(validDoc)
                  .collection('chats')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, selfSnapshot) {
                print(selfSnapshot.connectionState);
                print("within the stream builder");
                if (selfSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (selfSnapshot.connectionState ==
                    ConnectionState.active) {
                  return Expanded(
                      child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Container(
                                   width: MediaQuery.of(context).size.width * 0.3,
                                  child: ChatBubble(
                                      selfSnapshot.data.docs[index]['content'],
                                      selfSnapshot.data.docs[index]['sender'],
                                      selfSnapshot.data.docs[index]['userid'],
                                      widget.userData['imageurl']),
                                );
                              },
                              itemCount: selfSnapshot.data.docs.length,
                            ));
                } else {
                  return Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ChatBubble(
                          selfSnapshot.data.docs[index]['content'],
                          selfSnapshot.data.docs[index]['sender'],
                          selfSnapshot.data.docs[index]['userid'],
                          widget.userData['imageurl']);
                    },
                    itemCount: selfSnapshot.data.docs.length,
                  ));
                }
              },
            );
          }
        });
  }

  Future<DocumentSnapshot> idGenerator() async {
    final String docID1 = authInstance.currentUser.uid + widget.userData['uid'];
    final String docID2 = widget.userData['uid'] + authInstance.currentUser.uid;
    DocumentSnapshot document1 =
        await firestore.collection('messages').doc(docID1).get();
    if (document1.exists) {
      validDoc = docID1;
    }
    document1 = await firestore.collection('messages').doc(docID2).get();
    if (document1.exists) {
      validDoc = docID2;
    }
    return firestore.collection('messages').doc(validDoc).get();
  }
}
