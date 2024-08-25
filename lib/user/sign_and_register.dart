import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haruyume_app/home_page.dart';
import 'package:haruyume_app/user/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInRegisterPage extends StatefulWidget {
  const SignInRegisterPage({super.key});

  @override
  SignInRegisterPageState createState() => SignInRegisterPageState();
}

class SignInRegisterPageState extends State<SignInRegisterPage> {
  String infoText = '';
  String email = '';
  String password = '';
  String nickname = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // SignInPageに遷移する
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SignInPage()),
              );
            },
            child: const Text(
              'LOG IN',
              style: TextStyle(
                color: Colors.black, // ログインテキストの色
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email Address'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nickname'),
                onChanged: (String value) {
                  setState(() {
                    nickname = value;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(infoText),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () {
                    _registerUser();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Firestoreにユーザー情報を保存
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'id': user.uid,
          'email': email,
          'name': nickname,
          'note': "",
          'intelligence': 0,
          'care': 0,
          'power': 0,
          'skill': 0,
          'patience': 0,
          'thanks': 0,
        });

        // ログイン情報をSharedPreferencesに保存
        await _saveLoginInfo(userCredential.user!.uid);

        // ホーム画面に遷移
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    } catch (e) {
      // エラーハンドリング
      if (mounted) {
        setState(() {
          infoText = "Register failed: ${e.toString()}";
        });
      }
    }
  }

  Future<void> _saveLoginInfo(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', userId);
    await prefs.setBool('is_logged_in', true);
  }
}
