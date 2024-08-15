import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/settings/japanese_weekdays.dart';

class APIS {
  static Future<void> addToSheet(
      int harukaCounter, int yumekoCounter, user) async {
    final dateString =
        "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";

    //WEBデプロイしたURL
    String url =
        "https://script.google.com/macros/s/AKfycbwQ6zYYfdiOR3-sqVeIQYp1q3VZSpU3YtTxETB7QS4ELOpLB4vj4IRpC7200c9kqrs/exec";

    try {
      debugPrint("start submitting the form");
      final body = jsonEncode({
        'amount': harukaCounter,
        'category': harukaCounter,
        'date': dateString,
        'note': yumekoCounter,
        'user': user,
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
}
