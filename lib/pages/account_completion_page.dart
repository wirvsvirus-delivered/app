import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivered/services/auth.dart';
import 'package:delivered/utils/form_utils.dart';
import 'package:flutter/material.dart';

class AccountCompletionPage extends StatefulWidget {
  AccountCompletionPage({this.auth, this.next});

  final Auth auth;
  final Function next;

  @override
  State<StatefulWidget> createState() => new _AccountCompletionPageState();
}

class _AccountCompletionPageState extends State<AccountCompletionPage> {
  final _formKey = new GlobalKey<FormState>();

  String _fistName;
  String _lastName;
  String _street;
  String _houseNumber;
  int _zip;
  int _birth;

  Future<Map<String, String>> _contains;

  @override
  void initState() {
    super.initState();
    _contains = widget.auth.getAccountInfoStatus();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Ein letzter Schritt"),
        ),
        body: FutureBuilder<Map<String, String>>(
            future: _contains,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, String>> snapshot) {
              if (snapshot.hasData) {
                return new Container(
                    padding: EdgeInsets.all(16.0),
                    child: new Form(
                        key: _formKey,
                        child:
                            new ListView(shrinkWrap: true, children: <Widget>[
                          showNameInput(
                              snapshot.data["fname"], snapshot.data["lname"]),
                          showStreetInput(
                              snapshot.data["street"], snapshot.data["number"]),
                          showZipInput(snapshot.data["zip"]),
                          showBirthInput(snapshot.data["birth"]),
                          showButtons()
                        ])));
              }
              print(snapshot.data);
              return Center(child: CircularProgressIndicator());
            }));
  }

  Widget showNameInput(String firstName, String lastName) {
    return Row(
      children: <Widget>[
        Flexible(
          child: FormUtils.buildFormField(
              InputType.TEXT,
              'Vorname',
              Icons.face,
              (value) => null,
              (value) => _fistName = value.trim(),
              15,
              firstName != null,
              firstName),
        ),
        Flexible(
          child: FormUtils.buildFormField(
              InputType.TEXT,
              'Nachname',
              null,
              (value) => null,
              (value) => _lastName = value.trim(),
              15,
              lastName != null,
              lastName),
        ),
      ],
    );
  }

  Widget showStreetInput(String street, String number) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          child: FormUtils.buildFormField(
              InputType.TEXT,
              'Straße',
              Icons.home,
              (value) => null,
              (value) => _street = value.trim(),
              15,
              street != null,
              street),
        ),
        Flexible(
            child: FormUtils.buildFormField(
                InputType.TEXT,
                'Hausnummer',
                null,
                (value) => null,
                (value) => _houseNumber = value,
                15,
                number != null,
                number)),
      ],
    );
  }

  Widget showZipInput(String zip) {
    return FormUtils.buildFormField(
        InputType.NUMBER,
        'Postleihzahl',
        Icons.location_city,
        (value) => value.toString().length != 5 || value.toString().length != 0
            ? "Eine Postleihzahl muss 5 Zeichen haben"
            : null,
        (value) => _zip = int.parse(value),
        15,
        zip != null,
        zip);
  }

  Widget showBirthInput(String birth) {
    return FormUtils.buildFormField(
        InputType.DATE, 'Geburtsdatum', Icons.cake, (value) => null, (value) {
      if (value == "") {
        _birth = null;
      }
      _birth = (DateTime(
                      int.parse(value.toString().split(".")[2]),
                      int.parse(value.toString().split(".")[1]),
                      int.parse(value.toString().split(".")[0]))
                  .millisecondsSinceEpoch /
              1000)
          .floor();
    }, 15, birth != null, birth);
  }

  Widget showButtons() {
    return Row(children: <Widget>[
      FormUtils.buildButton(context, false, "Überspringen", widget.next),
      FormUtils.buildButton(context, true, "Speichern", validateAndSubmit)
    ]);
  }

  void validateAndSubmit() async {
    if (FormUtils.validateAndSave(_formKey)) {
      try {
        sendAccountInfo();
        widget.next();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void sendAccountInfo() async {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: 'completeProfile',
    );
    _contains.then((contains) {
      Map<String, dynamic> req = <String, dynamic>{};
      for (String s in contains.keys) {
        if (contains[s] == null) {
          var key;
          if (s == "fname") {
            key = _fistName;
          } else if (s == "lname") {
            key = _lastName;
          } else if (s == "street") {
            key = _street;
          } else if (s == "number") {
            key = _houseNumber;
          } else if (s == "zip") {
            key = _zip;
          } else if (s == "birth") {
            key = _birth;
          }
          if (key == "") {
            continue;
          }
          req[s] = key;
        }
      }

      dynamic resp = callable.call(req);
    });
  }
}
