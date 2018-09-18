import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'DiaryModel.dart';

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

  static Future init()async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'diary.db');

    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              "CREATE TABLE $tableName ("
                  "$columnPrimary STRING PRIMARY KEY,"
                  "$columnMorning_1,"
                  "$columnMorning_2,"
                  "$columnMorning_3,"
                  "$columnNight_1,"
                  "$columnNight_2,"
                  "$columnNight_3,"
                  ")");
        });
  }

  static Future<List> getDiaries() async{
    List<Diary> diaries;
    List<Map> result = await db.rawQuery('SELECT * FROM $tableName ORDER BY $columnPrimary');
    if(result.length == 0)
      return;

    for(int i = 0; i < result.length; i++){
      String year = result[i]['$columnPrimary'].toString().substring(0, 3);
      String month = result[i]['$columnPrimary'].toString().substring(4, 5);
      String day = result[i]['$columnPrimary'].toString().substring(6, 7);

      List<String> morning = [result[i]['$columnMorning_1'],
                              result[i]['$columnMorning_2'],
                              result[i]['$columnMorning_3']];

      List<String> night = [result[i]['$columnNight_1'],
                            result[i]['$columnNight_2'],
                            result[i]['$columnNight_3']];

      diaries.add(new Diary(year, month, day, morning, night));
    }
    return diaries;
  }
}