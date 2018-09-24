import 'dart:async';

import 'package:flutter/material.dart';
import 'package:morning_diary/Header.dart';
import 'package:morning_diary/DiaryModel.dart';
import 'package:morning_diary/DatabaseManager.dart';

// DB에서 가져온 것 최신이 오늘 아니면 오늘 추가

// Refactoring
// 처음 초기화할때만 디비에서 가져온거 보여주고 그 이후로는 텍스트 셋 안해주기
// DiaryModel DB와의 관계 정리

class DiaryPage extends StatefulWidget {
  final DiaryModel diaryModel;
  final snackBar = SnackBar(
    content: Text('Saved!'),
    backgroundColor: Colors.blue,
    duration: Duration(milliseconds: 1500),
  );

  DiaryPage(this.diaryModel);

  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  List<TextEditingController> morningController = new List(3);
  List<TextEditingController> nightController = new List(3);

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 3; i++)
      morningController[i] = new TextEditingController();
    for (int i = 0; i < 3; i++)
      nightController[i] = new TextEditingController();

    if (widget.diaryModel.morning == []) {
      widget.diaryModel.morning = List(3);
    }
    if (widget.diaryModel.night == []) {
      widget.diaryModel.night = List(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Material(
        color: Colors.blueGrey,
        child: new ListView(
          children: <Widget>[
            new Header(now: widget.diaryModel),
            new Container(
              color: Colors.white,
              //height: MediaQuery.of(context).size.height * 0.45,
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
                        textComponent(
                            true, 1, widget.diaryModel.morning[0] ?? ''),
                        textComponent(
                            true, 2, widget.diaryModel.morning[1] ?? ''),
                        textComponent(
                            true, 3, widget.diaryModel.morning[2] ?? ''),
                      ],
                    ),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 20.0, bottom: 50.0),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: new Container(
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
                          textComponent(false, 1, widget.diaryModel.night[0]),
                          textComponent(false, 2, widget.diaryModel.night[1]),
                          textComponent(false, 3, widget.diaryModel.night[2]),
                        ],
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new Builder(builder: (BuildContext context) {
        return new FloatingActionButton(
            child: const Icon(Icons.done),
            onPressed: () {
              List<String> mornings = [];
              mornings.add(morningController[0].text);
              mornings.add(morningController[1].text);
              mornings.add(morningController[2].text);
              widget.diaryModel.morning = mornings;

              List<String> nights = [];
              nights.add(nightController[0].text);
              nights.add(nightController[1].text);
              nights.add(nightController[2].text);
              widget.diaryModel.night = nights;

              DiaryModel model = new DiaryModel(
                  widget.diaryModel.year,
                  widget.diaryModel.month,
                  widget.diaryModel.day,
                  mornings,
                  nights);
              DatabaseManager.insertDiary(model).then((success) {
                if (success) {
                  Scaffold.of(context).showSnackBar(widget.snackBar);
                } else {
                  print("insert failed");
                }
              });
            });
      }),
    );
  }

  Widget textComponent(bool day, int num, String text) {
    if (day && morningController[num - 1].text != text)
      morningController[num - 1].text = text;
    else if (!day && nightController[num - 1].text != text)
      nightController[num - 1].text = text;

    return new Row(
      children: <Widget>[
        new Container(
          child: new Text('$num. ', textScaleFactor: 1.0),
          padding: EdgeInsets.only(right: 3.0),
        ),
        new Expanded(
          child: new TextField(
            scrollPadding: EdgeInsets.only(bottom: 100.0),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller:
                day ? morningController[num - 1] : nightController[num - 1],
            onChanged: (text) {
              day
                  ? widget.diaryModel.morning[num - 1] =
                      morningController[num - 1].text
                  : widget.diaryModel.night[num - 1] =
                      nightController[num - 1].text;
            },
          ),
        ),
      ],
    );
  }
}
