import 'package:flutter/material.dart';
import '../widgets/chatDisplay.dart';
import '../widgets/newChat.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(routeArgs['imageurl']),),
            SizedBox(width: 10,),
            Text(routeArgs['username']),
          ],
        ),
        // leading: ImageIcon(routeArgs['profileimage'])
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [ChatDisplay(routeArgs), NewChat(routeArgs)],
      ),
    );
  }
}
