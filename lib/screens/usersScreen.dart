import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isDone = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        primary: true,
        slivers:<Widget> [
          SliverAppBar(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(95),bottomLeft:Radius.circular(20) )),
            floating: true,
            titleSpacing: 10,
            centerTitle: true,
            title: Text("ChatEm",style: TextStyle(fontSize:50),),
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
          )
        ],
      ),
    );
  }
}
