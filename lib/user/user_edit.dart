import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/home_page.dart';

class UserEdit extends StatefulWidget {
  const UserEdit({super.key});

  @override
  State<UserEdit> createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final TextEditingController _textContName = TextEditingController();
  final TextEditingController _textContProf = TextEditingController();
  bool _isLoading = true; // ロード中かどうかを示すフラグ
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      // ユーザー情報を非同期で取得
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() {
          _errorMessage = 'UIDが取得できませんでした。';
        });
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userData = snapshot.data();

      if (userData != null) {
        _textContName.text = userData['name'] ?? '';
        _textContProf.text = userData['note'] ?? '';
      } else {
        setState(() {
          _errorMessage = 'ユーザーデータが見つかりませんでした。';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'ユーザーデータの取得に失敗しました: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(_errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ));
          },
        ),
        centerTitle: true,
        title: const Text('ユーザー登録'),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: OutlinedButton(
              child: const Text('保存', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // 保存ボタンが押されたときの処理
              },
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomSpace),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.grey))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, right: 40.0),
                        child: Text('ユーザーID'),
                      ),
                      Flexible(
                        child: TextField(
                          autofocus: false,
                          controller: _textContName,
                          maxLines: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 10.0),
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 1.0, color: Colors.grey))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, right: 40.0),
                        child: Text('自己紹介（必須ではない）'),
                      ),
                      Flexible(
                        child: TextField(
                          autofocus: false,
                          controller: _textContProf,
                          maxLines: 2,
                          minLines: 1,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
