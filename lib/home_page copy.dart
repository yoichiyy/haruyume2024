// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:myapp/home_card_kakei.dart';
// import 'package:myapp/settings/api.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//   @override
//   HomePageState createState() => HomePageState();
// }

// class MonthlyBookCount {
//   MonthlyBookCount({required this.monthlyHaruka, required this.monthlyYumeko});
//   final int monthlyHaruka;
//   final int monthlyYumeko;
// }

// class HomePageState extends State<HomePage> {
//   int harukaCounter = 0;
//   int yumekoCounter = 0;
//   int totalHaruka = 0;
//   int totalYumeko = 0;
//   int monthlyHaruka = 0;
//   int monthlyYumeko = 0;
//   String? userName = "";

//   // 家計簿管理部分で使用される変数
//   final kakeiController = TextEditingController();
//   final kakeiNoteController = TextEditingController();

//   void _checked(int index) {
//     setState(() {
//       checkedList.clear();
//       checkedList.add(index);
//     });
//   }

//   void _unchecked(int index) {
//     setState(() {
//       checkedList.remove(index);
//     });
//   }

//   String category = "";
//   final List<IconData> categoryIconList = [
//     Icons.dining,
//     Icons.coffee,
//     Icons.fastfood,
//     Icons.directions_run,
//     Icons.local_hospital,
//     Icons.sports_kabaddi,
//     Icons.currency_rupee,
//     Icons.menu_book,
//     Icons.local_fire_department,
//     Icons.train,
//     Icons.pest_control_rodent,
//     Icons.bedtime,
//     Icons.cottage,
//     Icons.electric_bolt,
//     Icons.android,
//   ];

//   final List<String> categoryList = [
//     "食事",
//     "嗜好品",
//     "外食",
//     "健康",
//     "医療",
//     "衣服",
//     "投資",
//     "本",
//     "GIVE",
//     "交通",
//     "日用品",
//     "その他",
//     "家",
//     "水光熱",
//     "子ども",
//   ];

//   int castId = 0;
//   final List<int> checkedList = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchInitialData().then((initialData) {
//       setState(() {
//         monthlyHaruka = initialData.monthlyHaruka;
//         monthlyYumeko = initialData.monthlyYumeko;
//       });
//     });
//     _fetchUserName(); // 追加: ユーザー名を取得する関数の呼び出し
//   }

//   Future<void> _fetchUserName() async {
//     final uid = FirebaseAuth.instance.currentUser?.uid;
//     if (uid != null) {
//       final DocumentSnapshot userDoc =
//           await FirebaseFirestore.instance.collection('users').doc(uid).get();
//       setState(() {
//         userName = userDoc['name'];
//       });
//     }
//   }

//   //スプレッドシートからデータを取得
//   static Future<MonthlyBookCount> _fetchInitialData() async {
//     try {
//       final url = GoogleApiSettings.getGoogleSheet();
//       final res = await http.get(Uri.parse(url));
//       //中身のチェック
//       final Map<String, dynamic> cellValues = json.decode(res.body);
//       final List<dynamic> row3 = cellValues['values'][2];

//       if (row3.length >= 2) {
//         final monthlyHaruka = int.tryParse(row3[1].toString()) ?? 0;
//         final monthlyYumeko = int.tryParse(row3[2].toString()) ?? 0;
//         return MonthlyBookCount(
//             monthlyHaruka: monthlyHaruka, monthlyYumeko: monthlyYumeko);
//       } else {
//         throw ('Invalid data format in B3 and C3 cells.');
//       }
//     } catch (e) {
//       debugPrint(e.toString()); // エラーはログに出力して握りつぶす
//       return MonthlyBookCount(monthlyHaruka: 0, monthlyYumeko: 0); // デフォルト値を返す
//     }
//   } //fetchInitData

//   void _incrementHaruka() {
//     setState(() {
//       harukaCounter++;
//     });
//   }

//   void _incrementYumeko() {
//     setState(() {
//       yumekoCounter++;
//     });
//   }

//   Future<void> _addToSheetInBackground() async {
//     await APIS.addKakeiboToSheet(
//         kakeiController.text, category, kakeiNoteController.text, userName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('はるゆめ絵本'),
//       ),
//       body: GestureDetector(
//         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//         behavior: HitTestBehavior.opaque,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               if (userName != null) Text('こんにちは、$userName さん'),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     children: [
//                       ElevatedButton(
//                         onPressed: _incrementHaruka,
//                         child: const Text('はるか'),
//                       ),
//                       Text('今月のトータル数字: $monthlyHaruka'),
//                       Text('カウンター: $harukaCounter'),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       ElevatedButton(
//                         onPressed: _incrementYumeko,
//                         child: const Text('ゆめこ'),
//                       ),
//                       Text('今月のトータル数字: $monthlyYumeko'),
//                       Text('カウンター: $yumekoCounter'),
//                     ],
//                   ),
//                 ],
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   await APIS.addBookToSheet(
//                       harukaCounter, yumekoCounter, userName);
//                   await APIS.bookNumRegister(harukaCounter, "haru");
//                   await APIS.bookNumRegister(yumekoCounter, "yume");
//                   setState(() {
//                     harukaCounter = 0;
//                     yumekoCounter = 0;
//                   });
//                 },
//                 child: const Text('送信'),
//               ),
//               const SizedBox(height: 20), // 絵本カウント部分と家計簿管理部分の間のスペース

//               // 家計簿管理部分
//               HomeCardWidgetKakei(
//                 title: "おこづかい",
//                 color: Colors.green[100]!,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Center(
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             keyboardType: TextInputType.number,
//                             controller: kakeiController,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             decoration: const InputDecoration(hintText: "金額"),
//                           ),
//                           const SizedBox(
//                             width: 10,
//                             height: 10,
//                           ),
//                           TextFormField(
//                             controller: kakeiNoteController,
//                             decoration: const InputDecoration(hintText: "メモ"),
//                           ),
//                           const SizedBox(
//                             width: double.infinity,
//                             height: 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       width: double.infinity,
//                       height: 20,
//                     ),
//                     GridView.builder(
//                       padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 4,
//                         mainAxisSpacing: 4,
//                         crossAxisSpacing: 8,
//                         childAspectRatio: 3,
//                       ),
//                       itemCount: 15,
//                       itemBuilder: (context, index) {
//                         final bool checked = checkedList.contains(index);
//                         return InkWell(
//                           child: checked == false
//                               ? Container(
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     border: Border.all(color: Colors.black26),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     categoryList[index],
//                                     style: const TextStyle(
//                                         color: Colors.black45, fontSize: 12),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 )
//                               : Container(
//                                   alignment: Alignment.center,
//                                   decoration: BoxDecoration(
//                                     color: Colors.yellow[200],
//                                     border: Border.all(),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Icon(
//                                     categoryIconList[index],
//                                     size: 20,
//                                     color: Colors.black54,
//                                   ),
//                                 ),
//                           onTap: () {
//                             castId = index;
//                             if (checked) {
//                               _unchecked(index);
//                               category = "";
//                             } else {
//                               _checked(index);
//                               setState(() => category = categoryList[index]);
//                             }
//                           },
//                         );
//                       },
//                       shrinkWrap: true,
//                     ),
//                     MaterialButton(
//                       color: Colors.lightBlue.shade900,
//                       onPressed: () {
//                         HapticFeedback.mediumImpact();
//                         FocusScope.of(context).unfocus();
//                         if (kakeiController.text.isEmpty || category.isEmpty) {
//                           showDialog<AlertDialog>(
//                             context: context,
//                             builder: (context) {
//                               return AlertDialog(
//                                 title: const Text("Oops"),
//                                 content: const Text("ちゃんと書きなさい"),
//                                 actions: [
//                                   TextButton(
//                                     child: const Text('OK'),
//                                     onPressed: () {
//                                       FocusScope.of(context).unfocus();
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                           return;
//                         } else {
//                           _addToSheetInBackground();
//                         }
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: const Text('おめでとうございます。'),
//                             behavior: SnackBarBehavior.floating,
//                             duration: const Duration(milliseconds: 400),
//                             margin: EdgeInsets.only(
//                                 bottom: MediaQuery.of(context).size.height / 2 -
//                                     50),
//                           ),
//                         );
//                         setState(() {
//                           kakeiController.clear();
//                           kakeiNoteController.clear();
//                           checkedList.clear();
//                         });
//                       },
//                       child: const Text(
//                         "登録",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                       height: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
