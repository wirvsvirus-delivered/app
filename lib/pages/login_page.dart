import 'dart:developer';

import 'package:delivered/services/auth.dart';
import 'package:delivered/utils/form_utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final Function loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoading;

  // Anmelden oder Registrieren
  void validateAndSubmit(bool isLogin) async {
    if (FormUtils.validateAndSave(_formKey)) {
      String userId = "";
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      try {
        if (isLogin) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }

        // Callback aufrufen um auf der root page die Seite zu wechseln
        if (userId.length > 0 && userId != null) {
          widget.loginCallback(isLogin);
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          // Serverseitige Fehlermeldungen
          _isLoading = false;
          if (e.code == "ERROR_USER_NOT_FOUND" ||
              e.code == "ERROR_WRONG_PASSWORD") {
            _errorMessage = "E-Mail oder Passwort falsch";
          } else if (e.code == "ERROR_INVALID_EMAIL") {
            _errorMessage = "E-Mail-Adresse ist im falschen Format";
          } else if (e.code == "ERROR_NETWORK_REQUEST_FAILED") {
            _errorMessage =
                "Verbindung fehlgeschlagen. Bitte überprüfe deine Internet-Verbindung";
          } else {
            _errorMessage = e.message;
          }
          // _formKey.currentState.reset();
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void resetForm() {
    // _formKey.currentState.reset();
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Registrieren und Anmelden"),
        ),
        body: _showForm());
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verifiziere deine E-Mail-Adresse"),
          content: new Text(
              "Ein Link dafür sollte bereits an deine E-Mail-Adresse geschickt worden sein"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _showForm() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(shrinkWrap: true, children: <Widget>[
            showLogo(),
            showEmailInput(),
            showPasswordInput(),
            Padding(
                padding: new EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                child: Center(
                  child: Row(children: <Widget>[
                    FormUtils.buildButton(context, false, "Registrieren",
                        () => validateAndSubmit(false)),
                    FormUtils.buildButton(context, true, "Anmelden",
                        () => validateAndSubmit(true))
                  ]),
                )),
            showErrorMessage()
          ]),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return FormUtils.buildFormField(
        InputType.EMAIL,
        'E-Mail',
        Icons.mail,
        (value) => value.isEmpty ? 'E-Mail kann nicht lehr sein' : null,
        (value) => _email = value.trim(),
        100,
        false,
        "");
  }

  Widget showPasswordInput() {
    return FormUtils.buildFormField(InputType.PASSWORD, 'Passwort', Icons.lock,
        (value) {
      if (value.isEmpty) {
        return 'Passwort kann nicht lehr sein';
      } else if (value.toString().length < 6) {
        return 'Passwort zu kurz';
      }
      return null;
    }, (value) => _password = value.trim(), 15, false, "");
  }
}
