import 'dart:developer';

import 'package:delivered/services/auth.dart';
import 'package:delivered/utils/form_utils.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit(bool isLogin) async {
    if (validateAndSave()) {
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
          //widget.auth.sendEmailVerification();
          //_showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.code;
          _formKey.currentState.reset();
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

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

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
                    buildButton(
                        false, "Registrieren", () => validateAndSubmit(false)),
                    buildButton(true, "Anmelden", () => validateAndSubmit(true))
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
        100);
  }

  Widget showPasswordInput() {
    return FormUtils.buildFormField(InputType.PASSWORD, 'Passwort', Icons.lock, (value) {
      if (value.isEmpty) {
        return 'Passwort kann nicht lehr sein';
      } else if(value.toString().length < 6) {
        return 'Passwort zu kurz';
      }
      return null;
    }, (value) => _password = value.trim(), 15);
  }

  Widget buildButton(bool primary, String text, Function onPress) {
    return Expanded(
      child: FlatButton(
        color: primary ? Theme.of(context).accentColor : null,
        child: new Text(text, style: Theme.of(context).textTheme.button),
        onPressed: onPress,
      ),
    );
  }
}
