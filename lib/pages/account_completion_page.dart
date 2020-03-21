import 'package:delivered/services/auth.dart';
import 'package:flutter/material.dart';

class AccountCompletionPage extends StatefulWidget {
  AccountCompletionPage({this.auth});

  final Auth auth;

  @override
  State<StatefulWidget> createState() => new _AccountCompletionPageState();
}

class _AccountCompletionPageState extends State<AccountCompletionPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Ein letzter Schritt"),
        ),
        body: Center(
          child: Text("Hier entsteht eine Account-Erweiterung"),
        ));
  }
}
