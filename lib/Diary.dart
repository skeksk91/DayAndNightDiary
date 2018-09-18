import 'package:flutter/material.dart';
import 'package:morning_diary/Header.dart';

class Diary extends StatelessWidget {
  final DateTime time;

  Diary(this.time);

  Widget textComponent(int num) {
    return new Row(
      children: <Widget>[
        new Container(
          child: new Text('$num. ', textScaleFactor: 1.0),
          padding: EdgeInsets.only(right: 3.0),
        ),
        new Expanded(
          child: new TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Material(
        color: Colors.blueGrey,
        child: new ListView(
          children: <Widget>[
            new Header(now:time),
            new Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.45,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    child: new Image(
                      image: AssetImage('assets/sun.png'),
                      width: 50.0,
                      height: 50.0,
                    ),
                    padding: EdgeInsets.only(left: 25.0),
                  ),
                  new Container(
                    padding: const EdgeInsets.only(top: 10.0),
                  ),
                  new Container(
                    padding:
                    EdgeInsets.symmetric(vertical: 3.0, horizontal: 30.0),
                    child: new Column(
                      children: <Widget>[
                        textComponent(1),
                        textComponent(2),
                        textComponent(3),
                      ],
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: new Container(
                height: MediaQuery.of(context).size.height * 0.4,
                color: Colors.blueGrey,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Image(
                        image: AssetImage('assets/moon.png'),
                        width: 50.0,
                        height: 50.0,
                      ),
                      padding: EdgeInsets.only(left: 25.0),
                    ),
                    new Container(
                      padding:
                      EdgeInsets.symmetric(vertical: 3.0, horizontal: 30.0),
                      child: new Column(
                        children: <Widget>[
                          textComponent(1),
                          textComponent(2),
                          textComponent(3),
                        ],
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(top: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
