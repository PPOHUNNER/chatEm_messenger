import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/authForm.dart';
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final authInstance = FirebaseAuth.instance;
  bool _viewPassword = false;
  bool _accountExists = false;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child:AuthForm(accountExists: _accountExists,viewPassword: _viewPassword,) ,
      ),
    );
  }

  
}
