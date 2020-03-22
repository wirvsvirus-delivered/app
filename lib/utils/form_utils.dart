import 'package:flutter/material.dart';

enum InputType { TEXT, NUMBER, EMAIL, PASSWORD, DATE }

class FormUtils {
  static Widget buildFormField(
      InputType type,
      String hint,
      IconData icon,
      Function validator,
      Function save,
      double padding,
      bool readonly,
      String value) {
    return Padding(
      padding: new EdgeInsets.fromLTRB(0.0, padding, 10.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        readOnly: readonly,
        initialValue: value,
        keyboardType: () {
          if (type == InputType.EMAIL) {
            return TextInputType.emailAddress;
          } else if (type == InputType.NUMBER) {
            return TextInputType.number;
          } else if (type == InputType.DATE) {
            return TextInputType.datetime;
          }
          return null;
        }(),
        obscureText: type == InputType.PASSWORD,
        autofocus: false,
        decoration: _getInputDecoration(hint, icon),
        validator: validator,
        onSaved: save,
      ),
    );
  }

  static InputDecoration _getInputDecoration(String hint, IconData icon) {
    if (icon != null) {
      return new InputDecoration(
          hintText: hint,
          icon: new Icon(
            icon,
            color: Colors.grey,
          ));
    }
    return new InputDecoration(hintText: hint);
  }

  static Widget buildButton(
      BuildContext context, bool primary, String text, Function onPress) {
    return Expanded(
      child: FlatButton(
        color: primary ? Theme.of(context).accentColor : null,
        child: new Text(text, style: Theme.of(context).textTheme.button),
        onPressed: onPress,
      ),
    );
  }

  static bool validateAndSave(GlobalKey<FormState> key) {
    final form = key.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
