import 'dart:developer';

import 'package:delivered/pages/login_page.dart';
import 'package:delivered/services/auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({this.auth, this.logoutCallback});

  Auth auth;
  Function logoutCallback;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: () {
      widget.auth.signOut();
      widget.logoutCallback();
    });
  }
}
