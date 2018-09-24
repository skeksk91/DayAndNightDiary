import 'package:flutter/material.dart';
import 'package:morning_diary/DiaryPage.dart';
import 'package:morning_diary/DiaryModel.dart';
import 'package:morning_diary/DatabaseManager.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Diary Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = new PageController();

  List<DiaryPage> _pages = [];

  @override
  void initState() {
    super.initState();
    var result = DatabaseManager.init(); //Error check
    result.then((ret) {
      DateTime now = new DateTime.now();

      if (ret == null ||
          (now.day != int.tryParse(ret[ret.length - 1].day) ||
              now.month != int.tryParse(ret[ret.length - 1].month) ||
              now.year != int.tryParse(ret[ret.length - 1].year))) {
        print("ADD");
        _pages.add(new DiaryPage(new DiaryModel('${now.year}', '${now.month}',
            '${now.day}', new List(3), new List(3))));
        if(ret == null) {
          jumpToLastPage();
          return;
        }
      }

      for (int i = 0; i < ret.length; i++) {
        DiaryModel d = ret[i];
        _pages.add(new DiaryPage(d));
      }

      jumpToLastPage();
    });
  }

  void jumpToLastPage() {
    this.setState(() {
      _controller.jumpToPage(_pages.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new PageView.builder(
      physics: new AlwaysScrollableScrollPhysics(),
      controller: _controller,
      itemCount: _pages.length,
      itemBuilder: (BuildContext context, int index) {
        return _pages[index];
      },
    );
  }
}
