import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/settings/japanese_weekdays.dart';

class GoogleApiSettings {
  static const String spreadsSheetsUrl =
      "1fMdeCbePbmxmJ_3rjz69g-ng1dOaoyuR9zZl6KugPy8";
  static const String bookSheet = "book";
  static const String routineSheet = "R";
  static const String apiKey = "AIzaSyAnoJBdD1vfTUXImK3ap8DJNBQbaO5svR4";

  static String getGoogleBookSheet() {
    if (spreadsSheetsUrl.isEmpty || bookSheet.isEmpty || apiKey.isEmpty) {
      throw ('please set google api settings.');
    }
    return 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsSheetsUrl/values/$bookSheet?key=$apiKey';
  }

  static String getGoogleRoutineSheet() {
    if (spreadsSheetsUrl.isEmpty || routineSheet.isEmpty || apiKey.isEmpty) {
      throw ('please set google api settings.');
    }
    return 'https://sheets.googleapis.com/v4/spreadsheets/$spreadsSheetsUrl/values/$routineSheet?key=$apiKey';
  }
}

class APIS {

  //Bonus追加

  static Future<void> addBonusToSheet(String whoseBonus, int amount, String note) async {
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




  //Routine →  絵本  →家計簿
  static Future<void> addRoutineToSheet(String text,String doneCell) async {
    // final dateString =
    //     "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";
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


  //絵本カウント
  static Future<void> addBookToSheet(
      int harukaCounter, int yumekoCounter) async {
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
      rethrow;
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

  // static Future<void> bookNumRegister(int booknum, String musume) async {
  //   // final snapshot =
  //   //     await FirebaseFirestore.instance.collection('users').doc(uid).get();
  //   // final userName = snapshot.data()!['name'] as String;
  //   final dailyCount =
  //       "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day.toString().padLeft(2, "0")}";

  //   final dateString =
  //       "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";
  //   final monthlyCount =
  //       "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}";
  //   final monthString = "${DateTime.now().year}年${DateTime.now().month}月";

  //   await FirebaseFirestore.instance
  //       .collection('newCount')
  //       // .doc(dailyCount + uid + musume)
  //       .doc(dailyCount + musume)
  //       .get()
  //       .then(
  //         (docSnapshot) => {
  //           if (docSnapshot.exists)
  //             {
  //               FirebaseFirestore.instance
  //                   .collection('newCount')
  //                   .doc(dailyCount + musume)
  //                   .update({"count": FieldValue.increment(booknum)})
  //             }
  //           else
  //             {
  //               FirebaseFirestore.instance
  //                   .collection('newCount')
  //                   .doc(dailyCount + musume)
  //                   .set(
  //                 <String, dynamic>{
  //                   "date": dateString,
  //                   "month": monthlyCount,
  //                   "count": booknum,
  //                   "user": "",
  //                   "time": "",
  //                   "musume": musume,
  //                 },
  //               ),
  //             },
  //         },
  //       ); //then

  //   // ここから、monthlyへの登録
  //   await FirebaseFirestore.instance
  //       .collection('monthHistory')
  //       .doc(monthlyCount + musume)
  //       .get()
  //       .then(
  //         (docSnapshot) => {
  //           if (docSnapshot.exists)
  //             {
  //               FirebaseFirestore.instance
  //                   .collection('monthHistory')
  //                   .doc(monthlyCount + musume)
  //                   .update({"count": FieldValue.increment(booknum)})
  //             }
  //           else
  //             {
  //               FirebaseFirestore.instance
  //                   .collection('monthHistory')
  //                   .doc(monthlyCount + musume)
  //                   .set(
  //                 <String, dynamic>{
  //                   "monthId": monthlyCount,
  //                   "count": booknum,
  //                   "month": monthString,
  //                   "musume": musume,
  //                 },
  //               ),
  //             },
  //         },
  //       ); //then
  // }
}
