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
                SlideShowEntry(
                    "Hilfe",
                    "Ältere Menschen, Menschen in Quarantäne oder mit Vorerkrankungen und eingeschränkte Menschen können oft nicht mehr selbst ihre Besorgen machen.",
                    Icons.accessibility_new),
                SlideShowEntry(
                    "Anrufen",
                    "Doch sie können bei delivered anrufen, wo ein ehrenamtlicher Helfer ihren Anruf entgegennimmt und als Auftrag abspeichert.",
                    Icons.call),
                SlideShowEntry(
                    "App",
                    "Die Aufträge werden in dieser App synchronisiert, wo du sie ausführst und an die Tür des Bestellers/der Bestellerin lieferst.",
                    Icons.phone_android)
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
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
