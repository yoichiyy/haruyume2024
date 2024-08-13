// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:myapp/home_page.dart';
// import 'package:myapp/user/sign_in.dart';

// class UserEdit extends StatefulWidget {
//   const UserEdit({super.key});

//   @override
//   State<UserEdit> createState() => _UserEditState();
// }

// class _UserEditState extends State<UserEdit> {
//   final TextEditingController _textContName = TextEditingController();
//   final TextEditingController _textContProf = TextEditingController();
//   // String _editTextName = '';
//   // String _editTextProf = '';

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const HomePage(),
//                 ));
//           },
//         ),
//         centerTitle: true,
//         title: const Text('ユーザー登録'),
//         actions: [
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//             child: OutlinedButton(
//               child: const Text('保存', style: TextStyle(color: Colors.white)),
//               onPressed: () async {
//                 User? user = FirebaseAuth.instance.currentUser;
//                 Map<String, dynamic> insertObj = <String, dynamic>{
//                   'id': user!.uid,
//                   'name': _textContName.text,
//                   'note': _textContProf.text,
//                   'intelligence': 0,
//                   'care': 0,
//                   'power': 0,
//                   'skill': 0,
//                   'patience': 0,
//                   'thanks': 0,
//                 };
//                 try {
//                   var doc = FirebaseFirestore.instance
//                       .collection('users')
//                       .doc(user.uid);
//                   await doc.set(insertObj, SetOptions(merge: true));
//                   //set:作成。もともとあったやつ、全部上書きされる。optionがある。merge trueにしたら。元あったフィールドはそのままになる。
//                   //または、if ...をつかう。

//                   await Navigator.push<MaterialPageRoute>(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const HomePage(),
//                     ),
//                   );
//                 } catch (e) {
//                   debugPrint(e.toString());
//                 }
//               },//async
//             ),
//           )
//         ],
//       ),
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           reverse: true,
//           child: Padding(
//             padding: EdgeInsets.only(bottom: bottomSpace),
//             //Column
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 15.0, horizontal: 10.0),
//                   decoration: const BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(width: 1.0, color: Colors.grey))),
//                   child: Row(
//                     // 名前
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       const Padding(
//                         padding: EdgeInsets.only(
//                             top: 10.0, bottom: 10.0, right: 40.0),
//                         child: Text('ユーザーID'),
//                       ),
//                       Flexible(
//                         child: TextField(
//                           autofocus: false,
//                           controller: _textContName,
//                           maxLines: 1,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 15.0, horizontal: 10.0),
//                   decoration: const BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(width: 1.0, color: Colors.grey))),
//                   child: Row(
//                     // 自己紹介
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       const Padding(
//                         padding: EdgeInsets.only(
//                             top: 10.0, bottom: 10.0, right: 40.0),
//                         child: Text('自己紹介（必須ではない）'),
//                       ),
//                       Flexible(
//                         child: TextField(
//                           autofocus: false,
//                           controller: _textContProf,
//                           maxLines: 2,
//                           minLines: 1,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ], //children
//             ), //column
//           ),
//         ),
//       ),
//     );
//   }
// }

// //2番目

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:myapp/home_page.dart';
// import 'package:myapp/user/sign_in.dart';

// class UserEdit extends StatefulWidget {
//   const UserEdit({super.key});

//   @override
//   State<UserEdit> createState() => _UserEditState();
// }

// class _UserEditState extends State<UserEdit> {
//   final TextEditingController _textContName = TextEditingController();
//   final TextEditingController _textContProf = TextEditingController();
//   bool _isLoading = false; // ロード中かどうかを示すフラグ

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bottomSpace = MediaQuery.of(context).viewInsets.bottom;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.close),
//           onPressed: () {
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => const HomePage(),
//                 ));
//           },
//         ),
//         centerTitle: true,
//         title: const Text('ユーザー登録'),
//         actions: [
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//             child: OutlinedButton(
//               onPressed: _isLoading ? null : _saveUserData,
//               child: _isLoading
//                   ? const CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
//                   : const Text('保存',
//                       style: TextStyle(color: Colors.white)), // ロード中はボタンを無効化
//             ),
//           )
//         ],
//       ),
//       resizeToAvoidBottomInset: false,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           reverse: true,
//           child: Padding(
//             padding: EdgeInsets.only(bottom: bottomSpace),
//             //Column
//             child: Column(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 15.0, horizontal: 10.0),
//                   decoration: const BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(width: 1.0, color: Colors.grey))),
//                   child: Row(
//                     // 名前
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       const Padding(
//                         padding: EdgeInsets.only(
//                             top: 10.0, bottom: 10.0, right: 40.0),
//                         child: Text('ユーザーID'),
//                       ),
//                       Flexible(
//                         child: TextField(
//                           autofocus: false,
//                           controller: _textContName,
//                           maxLines: 1,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 15.0, horizontal: 10.0),
//                   decoration: const BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(width: 1.0, color: Colors.grey))),
//                   child: Row(
//                     // 自己紹介
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       const Padding(
//                         padding: EdgeInsets.only(
//                             top: 10.0, bottom: 10.0, right: 40.0),
//                         child: Text('自己紹介（必須ではない）'),
//                       ),
//                       Flexible(
//                         child: TextField(
//                           autofocus: false,
//                           controller: _textContProf,
//                           maxLines: 2,
//                           minLines: 1,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ], //children
//             ), //column
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveUserData() async {
//     setState(() {
//       _isLoading = true; // ロード中フラグを立てる
//     });

//     User? user = FirebaseAuth.instance.currentUser;

//     if (user == null) {
//       // ユーザーがnullの場合の処理
//       setState(() {
//         _isLoading = false;
//       });
//       final snackBar = SnackBar(
//         content: const Text('ユーザー情報が見つかりません。再度サインインしてください。'),
//         action: SnackBarAction(
//           label: 'OK',
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const SignInPage()),
//             );
//           },
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//       return; // 処理を中断
//     }

//     Map<String, dynamic> insertObj = <String, dynamic>{
//       'id': user.uid,
//       'name': _textContName.text,
//       'note': _textContProf.text,
//       'intelligence': 0,
//       'care': 0,
//       'power': 0,
//       'skill': 0,
//       'patience': 0,
//       'thanks': 0,
//     };

//     try {
//       var doc = FirebaseFirestore.instance.collection('users').doc(user.uid);
//       await doc.set(insertObj, SetOptions(merge: true));

//       await Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => const HomePage(),
//         ),
//       );
//     } catch (e) {
//       debugPrint(e.toString());
//       setState(() {
//         _isLoading = false; // エラー発生時にロード中フラグを解除
//       });
//       final snackBar = SnackBar(
//         content: const Text('データの保存に失敗しました。もう一度お試しください。'),
//         action: SnackBarAction(
//           label: 'OK',
//           onPressed: () {},
//         ),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }
// }

