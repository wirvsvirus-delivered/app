import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivered/models/task.dart';
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
  Future<List<Task>> _tasks;

  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'userGetTasks',
  );

  @override
  void initState() {
    dynamic resp = callable.call({
      "zip": [83024, 83022],
      "over16": true,
      "over18": true
    });
    _tasks = resp.then<List<Task>>((data) {
      List<Task> tasks = [];
      for (dynamic object in data.data) {
        tasks.add(new Task([], false, false, false, false,
            new Address(object["street"], "", object["zip"], "de")));
      }
      return tasks;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text("delivered"), actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                widget.auth.signOut();
                widget.logoutCallback();
              })
        ]),
        body: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                  future: _tasks,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Task>> snapshot) {
                    print(snapshot.data);
                    if (snapshot.hasData) {
                      List<Widget> widgets = [];
                      for (Task task in snapshot.data) {
                        widgets.add(ListTile(
                            title: Text(task.address.street +
                                ", " +
                                task.address.country.toUpperCase() +
                                "-" +
                                task.address.zip.toString()),
                            onTap: () => log("Tap!")));
                      }
                      return ListView(children: widgets);
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            ),
          ],
        ));
  }
}
