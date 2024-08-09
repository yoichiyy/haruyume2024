import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/settings/japanese_weekdays.dart';

class APIS {
  static Future<void> addToSheet(
      int harukaCounter, int yumekoCounter) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final dateString =
        "${DateTime.now().month}/${DateTime.now().day}(${DateTime.now().japaneseWeekday})";

    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final user = snapshot.data()!['name'] as String;

    //WEBデプロイしたURL
    String _url =
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
      debugPrint("Json Succeeded:$body");

      //結果はどうだったか、サーバーから返されるresponseを取得
      http.Response response = await http.post(
        Uri.parse(_url),
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
