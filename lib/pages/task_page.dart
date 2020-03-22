import 'package:delivered/models/task.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  TaskPage({this.task});

  Task task;

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(title: Text(widget.task.address.toString())),
        body: Column(
          children: <Widget>[getItems()],
        ));
  }

  Widget getItems() {
    if (widget.task.items.length > 0) {
      // TODO: List items
    }
    return Container();
  }
}
