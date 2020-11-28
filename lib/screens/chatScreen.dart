import 'package:flutter/material.dart';
import '../widgets/chatDisplay.dart';
import '../widgets/newChat.dart';
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(routeArgs['username']),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ChatDisplay(routeArgs),
          NewChat(routeArgs)
        ],
      ),
    );
  }
}
