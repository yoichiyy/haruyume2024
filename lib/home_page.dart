import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/settings/api.dart';
import 'settings/eleki_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class MonthlyBookCount {
  MonthlyBookCount({required this.monthlyHaruka, required this.monthlyYumeko});
  final int monthlyHaruka;
  final int monthlyYumeko;
}

class HomePageState extends State<HomePage> {
  int harukaCounter = 0;
  int yumekoCounter = 0;
  int totalHaruka = 0;
  int totalYumeko = 0;
  int monthlyHaruka = 0;
  int monthlyYumeko = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialData().then((initialData) {
      setState(() {
        monthlyHaruka = initialData.monthlyHaruka;
        monthlyYumeko = initialData.monthlyYumeko;
      });
    });
  }

//スプレッドシートからデータを取得
  static Future<MonthlyBookCount> _fetchInitialData() async {
    try {
      final url = GoogleApiSettings.getGoogleSheet();
      final res = await http.get(Uri.parse(url));
      if (res.statusCode != 200) {
        throw ('データ取得失敗');
      }
      //中身のチェック
      final Map<String, dynamic> cellValues = json.decode(res.body);
      if (cellValues['values'] == null || cellValues['values'].length < 3) {
        throw ('セルの値がないよ');
      }
      //DEBUTPRING
      // debugPrint(cellValues.toString());
      // B3とC3セルの値を取得
      final List<dynamic> row3 = cellValues['values'][2];
      final uid = FirebaseAuth.instance.currentUser?.uid;

      debugPrint('${row3.toString()}表示されたらあかんやつ');
      debugPrint('${uid.toString()}UID');

      if (row3.length >= 2) {
        final monthlyHaruka = int.tryParse(row3[1].toString()) ?? 0;
        final monthlyYumeko = int.tryParse(row3[2].toString()) ?? 0;
        return MonthlyBookCount(
            monthlyHaruka: monthlyHaruka, monthlyYumeko: monthlyYumeko);
      } else {
        throw ('Invalid data format in B3 and C3 cells.');
      }
    } catch (e) {
      debugPrint(e.toString()); // エラーはログに出力して握りつぶす
      return MonthlyBookCount(monthlyHaruka: 0, monthlyYumeko: 0); // デフォルト値を返す
    }
  } //fetchInitData

  void _incrementHaruka() {
    setState(() {
      harukaCounter++;
    });
  }

  void _incrementYumeko() {
    setState(() {
      yumekoCounter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('はるゆめ絵本'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _incrementHaruka,
                    child: const Text('はるか'),
                  ),
                  Text('今月のトータル数字: $monthlyHaruka'),
                  Text('カウンター: $harukaCounter'),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: _incrementYumeko,
                    child: const Text('ゆめこ'),
                  ),
                  Text('今月のトータル数字: $monthlyYumeko'),
                  Text('カウンター: $yumekoCounter'),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              APIS.addToSheet(harukaCounter, yumekoCounter);
            },
            child: const Text('送信'),
          ),
        ],
      ),
    );
  }
}
