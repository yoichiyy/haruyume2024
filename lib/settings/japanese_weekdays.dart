extension DateTimeExtension on DateTime {
  //static const→ようぐぐり 定数のようなもの。他のクラスとは関係ない
  static const japaneseWeekdays = <String>["月", "火", "水", "木", "金", "土", "日"];
  //getterをはやす
  //this＝DateTimeのこと 
  String get japaneseWeekday => japaneseWeekdays[weekday - 1];
}//もともとのクラス名＋
