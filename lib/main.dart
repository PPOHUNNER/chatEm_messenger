import 'package:chatEm/screens/errorScreen.dart';
import 'package:chatEm/screens/usersScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/authScreen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    final authData = FirebaseAuth.instance;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/usersScreen': (context) => UserScreen(),
        '/authScreen':(context)=>AuthScreen()
        },
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return ErrorPage();
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ErrorPage();
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: authData.authStateChanges(),
                builder: (context, authSnapshots) {
                  if (authSnapshots.data == null) {
                    return AuthScreen();
                  }
                  return UserScreen();
                });
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
