import 'dart:developer';

import 'package:delivered/pages/account_completion_page.dart';
import 'package:delivered/pages/login_page.dart';
import 'package:delivered/pages/main_page.dart';
import 'package:delivered/pages/slider_page.dart';
import 'package:delivered/services/auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool showSlideshow = true;
  bool showAccountCompletion = false;

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  void loginCallback(login) {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    if (login) {
      // Bei login nach AccountCompletion abfragen
      widget.auth.isAccountInfoCompleted().then((value) {
        setState(() {
          showAccountCompletion = !value;
          authStatus = AuthStatus.LOGGED_IN;
        });
      });
    } else {
      // Bei Registrierung nicht, da:
      // 1. der Datenbank Eintrag für den Nutzer nicht in so kurzer Zeit erstellt werden kann
      // 2. nach Registrierung keine Nutzerdaten vorhanden sein können
      // Es wird immer die AccountCompletion angezeigt
      setState(() {
        showAccountCompletion = true;
        authStatus = AuthStatus.LOGGED_IN;
      });
    }
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    if (authStatus == AuthStatus.LOGGED_IN) {
      if (showAccountCompletion) {
        return new AccountCompletionPage(
            auth: widget.auth,
            next: () => setState(() => showAccountCompletion = false));
      }
      return new MainPage(auth: widget.auth, logoutCallback: logoutCallback);
    } else if (authStatus == AuthStatus.NOT_LOGGED_IN) {
      if (showSlideshow) {
        return new IntroSlideShowPage(
            onFinish: () => setState(() => showSlideshow = false));
      }
      return new LoginPage(auth: widget.auth, loginCallback: loginCallback);
    }
    return buildWaitingScreen();
  }
}
