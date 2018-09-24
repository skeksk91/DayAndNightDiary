import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:morning_diary/DiaryModel.dart';

class DatabaseManager {
  static Database db;

  static String tableName = "Diary";
  static String columnPrimary = "date";
  static String columnMorning_1 = "morning1";
  static String columnMorning_2 = "morning2";
  static String columnMorning_3 = "morning3";
  static String columnNight_1 = "night1";
  static String columnNight_2 = "night2";
  static String columnNight_3 = "night3";

  static Future<List> init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'diary.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "CREATE TABLE $tableName ("
                  "$columnPrimary STRING PRIMARY KEY,"
                  "$columnMorning_1 TEXT,"
                  "$columnMorning_2 TEXT,"
                  "$columnMorning_3 TEXT,"
                  "$columnNight_1 TEXT,"
                  "$columnNight_2 TEXT,"
                  "$columnNight_3 TEXT"
                  ")");
          });
    await db.execute(
      'DELETE FROM $tableName'
    );
//    await db.execute(
//        'INSERT INTO $tableName ($columnPrimary) VALUES("20180920")');

    List<Map> list = await db.rawQuery('SELECT * FROM $tableName');
    print(list);

    return getDiaries();
  }

  static Future<bool> insertDiary(DiaryModel model) async {
    if(model.day.length == 1) model.day = "0" + model.day;
    if(model.month.length == 1) model.month = "0" + model.month;

    try {
      await db.transaction((txn) async {
        await txn.rawInsert(
            'INSERT OR REPLACE INTO '
                '$tableName($columnPrimary, $columnMorning_1, $columnMorning_2,'
                '$columnMorning_3, $columnNight_1, $columnNight_2, $columnNight_3)'
                ' VALUES("${model.year}${model.month}${model.day}", "${model.morning[0]}", '
                '"${model.morning[1]}", "${model.morning[2]}", "${model.night[0]}",'
                ' "${model.night[1]}", "${model.night[2]}")');

      });
    }
    catch(e) {
      print("-----DB insert error-----");
      print(e.toString());
      return false;
    }
    return true;
  }

  static Future<List> getDiaries() async{
    List<DiaryModel> diaries = [];
    List<Map> result = await db.rawQuery('SELECT * FROM $tableName ORDER BY $columnPrimary');


    if(result.length == 0) {
      print("db select result is 0");
      return;
    }

    for(int i = 0; i < result.length; i++){
      String year = result[i]['$columnPrimary'].toString().substring(0, 4);
      String month = result[i]['$columnPrimary'].toString().substring(4, 6);
      String day = result[i]['$columnPrimary'].toString().substring(6, 8);

      List<String> morning = [result[i]['$columnMorning_1'],
                              result[i]['$columnMorning_2'],
                              result[i]['$columnMorning_3']];

      List<String> night = [result[i]['$columnNight_1'],
                            result[i]['$columnNight_2'],
                            result[i]['$columnNight_3']];

      diaries.add(new DiaryModel(year, month, day, morning, night));
    }
    return diaries;
  }
}