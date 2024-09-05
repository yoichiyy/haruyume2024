// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/monthly_book_count.dart';

class APIService {
  static Future<MonthlyBookCount> fetchInitialData() async {
    final url = "YOUR_GOOGLE_SHEET_URL";
    final res = await http.get(Uri.parse(url));
    final Map<String, dynamic> cellValues = json.decode(res.body);
    final List<dynamic> row3 = cellValues['values'][2];

    if (row3.length >= 2) {
      return MonthlyBookCount(
        monthlyHaruka: int.tryParse(row3[1].toString()) ?? 0,
        monthlyYumeko: int.tryParse(row3[2].toString()) ?? 0,
        haruROne: row3[6].toString(),
        // さらに他のフィールドも設定
      );
    } else {
      throw ('Invalid data format in B3 and C3 cells.');
    }
  }

  static Future<void> addKakeiboToSheet(
      String amount, String category, String note) async {
    // Google Sheetにデータを追加するロジック
  }

  static Future<void> addRoutineToSheet(String value, String cell) async {
    // ルーティンデータをシートに追加
  }

  static Future<void> addBonusToSheet(
      String type, int bonus, String note) async {
    // ボーナスをシートに追加する
  }
}
