import 'dart:developer';

import 'package:delivered/pages/login_page.dart';
import 'package:delivered/services/auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({this.auth});

  Auth auth;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    widget.auth.isAccountInfoCompleted().then((value) => log(value.toString()));
    return RaisedButton(onPressed: () => widget.auth.signOut());
  }
}
