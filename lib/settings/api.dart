import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/settings/japanese_weekdays.dart';

class GoogleApiSettings {
  static const String spreadsSheetsUrl =
      "1fMdeCbePbmxmJ_3rjz69g-ng1dOaoyuR9zZl6KugPy8";
  static const String sheetName = "book";
  static const String apiKey = "AIzaSyAnoJBdD1vfTUXImK3ap8DJNBQbaO5svR4";

  static String getGoogleSheet() {
    if (spreadsSheetsUrl.isEmpty || sheetName.isEmpty || apiKey.isEmpty) {
      throw ('please set google api settings.');
    }
    return 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsSheetsUrl/values/$sheetName?key=$apiKey';
  }
}

class APIS {
  static Future<void> addBookToSheet(
      int harukaCounter, int yumekoCounter, username) async {
    final dateString =
        "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";

    String url =
        "https://script.google.com/macros/s/AKfycby5FiSmh6i0YBI1zN1JguPvD6sJb76vIcZGqGTPv_BZh0awvQR0wQoMXv3pxiaFew/exec";

    try {
      debugPrint("start submitting the form");
      final body = jsonEncode({
        'amount': harukaCounter,
        'category': "book",
        'date': dateString,
        'note': yumekoCounter,
        'user': username,
      });
      debugPrint("Json Succeeded: $body");

      http.Response response = await http.post(
        Uri.parse(url),
        body: body,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      // ここでのエラーハンドリング
      debugPrint('HTTP Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseJson = jsonDecode(response.body);
        debugPrint('Response Status: ${responseJson['status']}');
      } else {
        debugPrint('Error: ${response.statusCode} - ${response.reasonPhrase}');
        debugPrint('Response body: ${response.body}');
      }
    } catch (e) {
      debugPrint('Request failed: $e');
      // ここでブレークポイントを設定してみる
      rethrow; // 必要に応じて例外を再スローする
    }
  }

  static Future<void> addKakeiboToSheet(
      String amount, String category, String note, username) async {
    final dateString =
        "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";

    String url =
        "https://script.google.com/macros/s/AKfycby5FiSmh6i0YBI1zN1JguPvD6sJb76vIcZGqGTPv_BZh0awvQR0wQoMXv3pxiaFew/exec";

    try {
      debugPrint("start submitting the form");
      final body = jsonEncode({
        'amount': amount,
        'category': category,
        'date': dateString,
        'note': note,
        'user': username,
      });
      debugPrint("Json Succeeded:$body");

      //結果はどうだったか、サーバーから返されるresponseを取得
      http.Response response = await http.post(
        Uri.parse(url),
        body: body,
        headers: <String, String>{
          //リクエストに関するメタ情報
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      debugPrint(responseJson[
          'status']); // This will output the "status" field of the response.

      debugPrint(response.body);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
