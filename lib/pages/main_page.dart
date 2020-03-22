import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:delivered/models/task.dart';
import 'package:delivered/pages/login_page.dart';
import 'package:delivered/pages/task_page.dart';
import 'package:delivered/services/auth.dart';
import 'package:delivered/services/location.dart';
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
  LocationService locationService = new LocationService();

  final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'userGetTasks',
  );

  @override
  void initState() {
    locationService.setup();

    // Postleihzahl nach GPS abrufen
    locationService.getZipByLocation().then((value) {
      print("Zip: $value");
      // Datenbank nach Tasks in der Nähe abfragen
      dynamic resp = callable.call({
        "zip": [value, 83024],
        "over16": true,
        "over18": true
      });
      setState(() {
        _tasks = resp.then<List<Task>>((data) {
          List<Task> tasks = [];
          print(data.data);
          for (dynamic object in data.data) {
            // Antwort in Objekte umwandeln
            tasks.add(new Task([], false, false, false, false,
                new Address(object["street"], "", object["zip"], "de")));
          }
          return tasks;
        });
      });
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
                    if (snapshot.hasData) {
                      List<Widget> widgets = [];
                      for (Task task in snapshot.data) {
                        widgets.add(ListTile(
                            title: Text(task.address.toString()),
                            onTap: () {
                              // Auf Task-Unterseite weiterleiten
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TaskPage(task: task)),
                              );
                            }));
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
