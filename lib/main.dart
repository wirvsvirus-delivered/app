import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'delivered',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: MaterialColor(0xfff08221, {
            50: Color(0xffFDF0E4),
            100: Color(0xffFBDABC),
            200: Color(0xffF8C190),
            300: Color(0xffF5A864),
            400: Color(0xffF29542),
            500: Color(0xffF08221),
            600: Color(0xffEE7A1D),
            700: Color(0xffEC6F18),
            800: Color(0xffE96514),
            900: Color(0xffE5520B)
          }),
          accentColor: Color(0xffab1c48)),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(title: 'delivered'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container());
  }
}