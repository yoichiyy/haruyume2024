// // pages/home_page.dart
// import 'package:flutter/material.dart';
// import '../models/monthly_book_count.dart';
// import '../services/api_service.dart';
// import '../widgets/routine_button.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   // State variables
//   late Future<MonthlyBookCount> initialData;

//   @override
//   void initState() {
//     super.initState();
//     initialData = APIService.fetchInitialData();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('はるゆめ絵本')),
//       body: FutureBuilder<MonthlyBookCount>(
//         future: initialData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return const Center(child: Text("エラーが発生しました"));
//           } else if (snapshot.hasData) {
//             final data = snapshot.data!;
//             return Column(
//               children: [
//                 Text('晴加のカウンター: ${data.monthlyHaruka}'),
//                 RoutineButton(
//                   currentTextNotifier: ValueNotifier(data.haruROne),
//                   originalText: 'Original',
//                   cell: 'B4',
//                   onPressedCallback: (newText, originalText, cell) {
//                     APIService.addRoutineToSheet(newText, cell);
//                   },
//                 ),
//                 // さらに他のウィジェットを追加
//               ],
//             );
//           } else {
//             return const Center(child: Text("データなし"));
//           }
//         },
//       ),
//     );
//   }
// }
