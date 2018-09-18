import 'package:flutter/material.dart';
import 'Diary.dart';
import 'DatabaseManager.dart';

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

  List<Diary> _pages;

  @override
  initState() async {
    super.initState();
    DatabaseManager.init(); //Error check
    _pages = await DatabaseManager.getDiaries();
    print(_pages);
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
