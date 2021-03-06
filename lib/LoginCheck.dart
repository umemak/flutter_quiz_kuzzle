import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'UserState.dart';
import 'LoginPage.dart';

class LoginCheck extends StatefulWidget {
  LoginCheck({Key? key, required this.nextPage}) : super(key: key);
  final String nextPage;

  @override
  _LoginCheckState createState() => _LoginCheckState();
}

class _LoginCheckState extends State<LoginCheck> {
  void checkUser() {
    final userState = Provider.of<UserState>(context, listen: false);
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacementNamed(context, LoginPage.routeName);
    } else {
      userState.setUser(FirebaseAuth.instance.currentUser!);
      Navigator.pushReplacementNamed(context, widget.nextPage);
    }
  }

  @override
  void initState() {
    super.initState();
    Future(() {
      checkUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}
