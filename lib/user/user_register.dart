import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:haruyume_app/home_page.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final TextEditingController _textContName = TextEditingController();
  bool _isLoading = true; // ロード中かどうかを示すフラグ
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    debugPrint('Start _initializeUserData');
    try {
      // ユーザー情報を非同期で取得
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() {
          _errorMessage = 'UIDが取得できませんでした。';
          _isLoading = false; // エラー時もロード終了とする
        });
        debugPrint('UID is null, setting errorMessage');
        return;
      }

      setState(() {
        _errorMessage = null;
      });
      debugPrint('User data initialized successfully');
    } catch (e) {
      setState(() {
        _errorMessage = 'ユーザーデータの取得に失敗しました: $e';
      });
    } finally {
      // 処理完了後、ロード終了とする
      setState(() {
        _isLoading = false;
      });
      debugPrint('End _initializeUserData');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomSpace = MediaQuery.of(context).viewInsets.bottom;

    if (_isLoading) {
      debugPrint('Loading state is true, showing CircularProgressIndicator');
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      debugPrint('Error state detected: $_errorMessage');
      return Scaffold(
        body: Center(child: Text(_errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            debugPrint('Close button pressed, navigating to HomePage');
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
                debugPrint('Save button pressed');
                User? user = FirebaseAuth.instance.currentUser;
                Map<String, dynamic> insertObj = <String, dynamic>{
                  'id': user!.uid,
                  'name': _textContName.text,
                  'note': "",
                  'intelligence': 0,
                  'care': 0,
                  'power': 0,
                  'skill': 0,
                  'patience': 0,
                  'thanks': 0,
                };
                try {
                  var doc = FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid);
                  await doc.set(insertObj, SetOptions(merge: true));
                  //set:作成。もともとあったやつ、全部上書きされる。optionがある。merge trueにしたら。元あったフィールドはそのままになる。
                  //または、if ...をつかう。

                  await Navigator.push<MaterialPageRoute>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                } catch (e) {
                  debugPrint(e.toString());
                }
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
                          autofocus: true,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
