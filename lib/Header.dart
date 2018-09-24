import 'package:flutter/material.dart';
import 'package:morning_diary/DiaryModel.dart';

class Header extends StatelessWidget {
  final DiaryModel now;

  const Header({
    Key key,
    @required this.now,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Text(
          '${now.year}.${now.month}.${now.day}',
          style: TextStyle(fontFamily: 'Nanum'),
          textScaleFactor: 2.0,
        ),
      ),
      padding: const EdgeInsets.only(top: 5.0),
      decoration: new BoxDecoration(color: Colors.white),
    );
  }
}