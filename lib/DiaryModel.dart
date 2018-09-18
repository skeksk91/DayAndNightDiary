import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Diary {
  String year;
  String month;
  String day;
  List<String> morning = [];
  List<String> night = [];

  Diary(this.year, this.month, this.day,
        this.morning, this.night);

  void getDataFromDatabase(){

  }
}