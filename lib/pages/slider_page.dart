import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroSlideShowPage extends StatefulWidget {
  IntroSlideShowPage({this.onFinish});

  final Function onFinish;

  @override
  _IntoSlideShowPageState createState() => _IntoSlideShowPageState();
}

class _IntoSlideShowPageState extends State<IntroSlideShowPage> {
  bool _buttonVisible = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Herzlich willkommen"),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: SlideShowPage([
                SlideShowEntry("Slide1", "Text1", Icons.done),
                SlideShowEntry("Slide2", "Text2", Icons.directions_run),
                SlideShowEntry("Slide3", "Text3", Icons.account_circle)
              ], () => setState(() => _buttonVisible = true)),
            ),
            SizedBox(
                width: double.infinity,
                height: 55.0,
                child: Visibility(
                  visible: _buttonVisible,
                  child: RaisedButton(
                      onPressed: widget.onFinish,
                      color: Theme.of(context).accentColor,
                      child: Text("Weiter")),
                ))
          ],
        ));
  }
}

class SlideShowPage extends StatelessWidget {
  SlideShowPage(this.entries, this.onLast);

  final List<SlideShowEntry> entries;
  final Function onLast;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CarouselSlider(
          onPageChanged: (pos) {
            if (pos == entries.length - 1) {
              onLast();
            }
          },
          enableInfiniteScroll: false,
          height: constraints.maxHeight,
          items: entries.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: i,
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class SlideShowEntry extends StatelessWidget {
  SlideShowEntry(this.title, this.subtitle, this.icon);

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: Theme.of(context).accentColor,
              size: MediaQuery.of(context).size.width * 0.3,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                title,
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
