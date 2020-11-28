import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isDone = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return CustomScrollView(
            primary: true,
            slivers: <Widget>[
              SliverAppBar(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(95),
                        bottomLeft: Radius.circular(20))),
                floating: true,
                titleSpacing: 10,
                centerTitle: true,
                title: Text(
                  "ChatEm",
                  style: TextStyle(fontSize: 50),
                ),
                expandedHeight: 150,
                actions: [
                  IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        setState(() {
                          isDone = true;
                        });
                        Navigator.of(context).popAndPushNamed('/authScreen');
                      }),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/chatScreen',
                              arguments: {
                                'username': userSnapshot.data.docs[index]
                                    ['username'],
                                    'uid':userSnapshot.data.docs[index]
                                    ['uid']
                              });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(userSnapshot
                                  .data.docs[index]['profileimage']),
                            ),
                            title:
                                Text(userSnapshot.data.docs[index]['username']),
                          ),
                        ),
                      ),
                      Divider()
                    ],
                  );
                }, childCount: userSnapshot.data.docs.length)),
              )
            ],
          );
        },
      ),
    );
  }
}
