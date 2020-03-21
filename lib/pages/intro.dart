import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class IntroSlideShowPage extends StatelessWidget {

  IntroSlideShowPage(this.height, this.entries);

  final List<IntroSlideShowEntry> entries;

  final double height;

  @override
  Widget build(BuildContext context) {

    return CarouselSlider(
      height: height,
      items: entries.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),
                child: i,
            );
          },
        );
      }).toList(),
    );
  }
}

class IntroSlideShowEntry extends StatelessWidget {
  IntroSlideShowEntry(this.title, this.subtitle, this.icon);

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
              color: Color(0xfff08221),
              size: MediaQuery.of(context).size.width * 0.3,
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Theme.of(context).accentColor,
                ),
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
