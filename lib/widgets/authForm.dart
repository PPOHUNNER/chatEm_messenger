import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  bool accountExists;
  bool viewPassword;
  AuthForm({this.accountExists, this.viewPassword});
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  bool isLoading = false;
  final authInstance = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
          horizontal: deviceSize.width * 0.08,
          vertical: deviceSize.width * 0.04),
      width: deviceSize.width * 0.8,
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              key: ValueKey("email"),
              decoration: InputDecoration(labelText: "Email"),
              controller: _emailController,
            ),
            SizedBox(
              height: deviceSize.width * 0.07,
            ),
            if (!widget.accountExists)
              TextField(
                key: ValueKey("username"),
                decoration: InputDecoration(labelText: "Username"),
                controller: _usernameController,
              ),
            if (!widget.accountExists)
              SizedBox(
                height: deviceSize.width * 0.07,
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    key: ValueKey("password"),
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: widget.viewPassword ? false : true,
                    controller: _passwordController,
                  ),
                ),
                IconButton(
                    icon: Icon(
                      widget.viewPassword ? Icons.visibility_off: Icons.remove_red_eye ,
                      color: widget.viewPassword ? Colors.blue : Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.viewPassword = !widget.viewPassword;
                      });
                    }),
              ],
            ),
            SizedBox(
              height: deviceSize.width * 0.07,
            ),
            FlatButton(
                onPressed: () {
                  _authValidate({
                    'email': _emailController.text,
                    'username': _usernameController.text,
                    'password': _passwordController.text
                  }, context);
                },
                child: isLoading ? CircularProgressIndicator() : Text(widget.accountExists ? "Sign In" : "Sign Up")),
            FlatButton(
                onPressed: () {
                  setState(() {
                    widget.accountExists = !widget.accountExists;
                  });
                },
                child: Text(widget.accountExists
                    ? "I don't have an account"
                    : "Do you have an account"))
          ],
        ),
      ),
    );
  }

  void _authValidate(Map<String, dynamic> userData, BuildContext ctx) async {
    {
      if (userData['email'].isEmpty && userData['password'].isEmpty) {
        Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text("Incomplete form"),
          duration: Duration(seconds: 2),
        ));
      } else if (widget.accountExists) {
        try {
          setState(() {
            isLoading = true;
          });
          await authInstance.signInWithEmailAndPassword(
              email: userData['email'], password: userData['password']);
              setState(() {
            isLoading = false;
          });
          Navigator.of(context).popAndPushNamed('/usersScreen');
        } catch (e) {
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(e.code),
            duration: Duration(seconds: 2),
          ));
          setState(() {
            isLoading = false;
          });
        }
      } else {
        try {
          setState(() {
            isLoading = true;
          });
          await authInstance.createUserWithEmailAndPassword(
              email: userData['email'], password: userData['password']);
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).popAndPushNamed('/usersScreen');
        } catch (e) {
          print(e);
          Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(e.code),
            duration: Duration(seconds: 2),
          ));
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }
}
