// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'home_page.dart';
// import 'settings/firebase_options.dart';
// import 'user/sign_and_register.dart';
// import 'user/sign_in.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter app',
//       home: FutureBuilder<bool>(
//         future: _checkLoginStatus(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const CircularProgressIndicator(); // ローディングインジケーター
//           }
//           if (snapshot.hasData && snapshot.data == true) {
//             return const HomePage();
//           } else {
//             return StreamBuilder<User?>(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator(); // ローディングインジケーター
//                 }
//                 if (snapshot.hasData) {
//                   // Firebase Authにユーザーが存在するが、SharedPreferencesに情報がない場合
//                   return const SignInPage();
//                 } else {
//                   // Firebase Authにユーザーが存在しない場合
//                   return const SignInRegisterPage();
//                 }
//               },
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<bool> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
//     return isLoggedIn;
//   }
// }
