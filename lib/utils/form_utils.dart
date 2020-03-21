import 'package:flutter/material.dart';

enum InputType { EMAIL, PASSWORD }

class FormUtils {
  static Widget buildFormField(InputType type, String hint, IconData icon,
      Function validator, Function save, double padding) {
    return Padding(
      padding: new EdgeInsets.fromLTRB(0.0, padding, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType:
        type == InputType.EMAIL ? TextInputType.emailAddress : null,
        obscureText: type == InputType.PASSWORD,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: hint,
            icon: new Icon(
              icon,
              color: Colors.grey,
            )),
        validator: validator,
        onSaved: save,
      ),
    );
  }
}