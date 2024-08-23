import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/home_page.dart';

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
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'address'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'password'),
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'nickname'),
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
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      auth
                          .createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      )
                          .then((userCredential) {
                        // ユーザーID（ニックネーム）などの情報をFirestoreに保存
                        final User? user = userCredential.user;
                        if (user != null) {
                          return FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .set({
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
                        } else {
                          throw Exception('could not get the user info');
                        }
                      }).then((_) {
                        // Firestoreへの保存が成功した場合に、次の画面に遷移
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                              return const HomePage();
                            }),
                          );
                        }
                      }).catchError((e) {
                        // エラーハンドリング
                        if (mounted) {
                          setState(() {
                            infoText = "register failed${e.toString()}";
                          });
                        }
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
