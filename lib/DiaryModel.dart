import 'Main.dart';

class DiaryModel {
  String year;
  String month;
  String day;
  List<String> morning = [];
  List<String> night = [];

  DiaryModel(this.year, this.month, this.day,
        this.morning, this.night);

  void getDataFromDatabase(){

  }
}