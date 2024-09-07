import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/services/api.dart';
import 'package:myapp/settings/japanese_weekdays.dart';

import '../models/monthly_book_count.dart';

class APIService {
  static Future<MonthlyBookCount> fetchInitialData() async {
    final url = GoogleApiSettings.getGoogleBookSheet();
    final res = await http.get(Uri.parse(url));
    final Map<String, dynamic> cellValues = json.decode(res.body);
    final List<dynamic> row3 = cellValues['values'][2];

    if (row3.length >= 2) {
      return MonthlyBookCount(
        monthlyHaruka: int.tryParse(row3[1].toString()) ?? 0,
        monthlyYumeko: int.tryParse(row3[2].toString()) ?? 0,
        haruROne: row3[6].toString(),
        haruRTwo: row3[7].toString(),
        haruRThree: row3[8].toString(),
        haruRFour: row3[9].toString(),
        yumeROne: row3[10].toString(),
        yumeRTwo: row3[11].toString(),
        yumeRThree: row3[12].toString(),
        yumeRFour: row3[13].toString(),
        haruGinko: int.tryParse(row3[14].toString()) ?? 0,
        yumeGinko: int.tryParse(row3[16].toString()) ?? 0,
        mamaROne: row3[18].toString(),
        mamaRTwo: row3[19].toString(),
        mamaRThree: row3[20].toString(),
        mamaRFour: row3[21].toString(),
        papaROne: row3[22].toString(),
        papaRTwo: row3[23].toString(),
        papaRThree: row3[24].toString(),
        papaRFour: row3[25].toString(),
        mamaGinko: int.tryParse(row3[26].toString()) ?? 0,
        papaGinko: int.tryParse(row3[28].toString()) ?? 0,
      );
    } else {
      throw ('Invalid data format in B3 and C3 cells.');
    }
  }

  static Future<void> addKakeiboToSheet(
      String amount, String category, String note) async {
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
        'user': "",
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

  static Future<void> addRoutineToSheet(String text, String doneCell) async {
    String url =
        "https://script.google.com/macros/s/AKfycby5FiSmh6i0YBI1zN1JguPvD6sJb76vIcZGqGTPv_BZh0awvQR0wQoMXv3pxiaFew/exec";

    debugPrint(text);
    debugPrint(doneCell);

    try {
      final body = jsonEncode({
        'amount': text,
        'category': "routine",
        'date': "",
        'note': doneCell,
        'user': "",
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
      rethrow;
    }
  }

  static Future<void> addBonusToSheet(
      String whoseBonus, int amount, String note) async {
    String url =
        "https://script.google.com/macros/s/AKfycby5FiSmh6i0YBI1zN1JguPvD6sJb76vIcZGqGTPv_BZh0awvQR0wQoMXv3pxiaFew/exec";

    debugPrint(whoseBonus);
    debugPrint(note);

    try {
      final body = jsonEncode({
        'amount': amount,
        'category': whoseBonus,
        'date': "",
        'note': note,
        'user': "",
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
      rethrow;
    }
  }
}
