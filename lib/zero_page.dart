// import 'package:counter/counter/home_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:counter/counter/num_count_model.dart';
// import 'package:counter/counter_history/history_model.dart';
// import 'package:counter/counter_history/history_model_month.dart';
// import 'package:counter/task_list/task_model.dart';
// import 'package:counter/ui/pageview.dart';
// import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../user/signin.dart';

import 'dart:convert';
import 'package:myapp/settings/api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/settings/eleki_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'settings/firebase_options.dart';

class MyApp extends StatelessWidget {
  const MyApp({required Key key}) : super(key: key);
  // const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final uid = FirebaseAuth.instance.currentUser!.uid;
    // final docRefUser = FirebaseFirestore.instance.collection('users').doc(uid);
    // final userInfo = await docRefUser.get();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TaskModel>(create: (_) => TaskModel()
            // ..getTodoListRealtime(),
            // ..getUserGraph(),
            ),
        // ChangeNotifierProvider<EditTaskModel>(create: (_) => EditTaskModel()),
        ChangeNotifierProvider<NumCountModel>(create: (_) => NumCountModel()),
        ChangeNotifierProvider<HistoryModel>(create: (_) => HistoryModel()),
        ChangeNotifierProvider<MonthlyHistoryModel>(
            create: (_) => MonthlyHistoryModel()),
        // ChangeNotifierProvider<TaskMonsterModel>(
        //     create: (_) => TaskMonsterModel()),
      ],
      child: MaterialApp(
        title: 'Flutter app',
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData) {
              // 1.User が null でなないこと確認 →ホームへ
              return const PageViewClass(key: ValueKey('pageView'));
            }
            //widget→変わらないものとして定義したいところ＝const

            // User が null である、つまり未サインインのサインイン画面へ
            return const SigninPage();
          },
        ),
      ),
    );
  } //まてりある
}


class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  MainPageState createState() => MainPageState();
}

class MonthlyBookCount {
  MonthlyBookCount({required this.monthlyHaruka, required this.monthlyYumeko});
  final int monthlyHaruka;                
  final int monthlyYumeko;
}

class MainPageState extends State<MainPage> {
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
      final url =
          GoogleApiSettings.getGoogleSheet();
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
      debugPrint(row3.toString());

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

