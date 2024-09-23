import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmotionClassifierScreen extends StatefulWidget {
  const EmotionClassifierScreen({super.key});

  @override
  EmotionClassifierScreenState createState() => EmotionClassifierScreenState();
}

class EmotionClassifierScreenState extends State<EmotionClassifierScreen> {
  final TextEditingController _textController = TextEditingController();
  String _classificationResult = ""; // 感情分類結果を表示
  String _selectedUser = "mama";
  bool _isButtonPressed = false;
  final FocusNode _focusNode = FocusNode();

  // ボタンを押した際に呼ばれる関数
  void _handleSubmit() {
    setState(() => _isButtonPressed = true); // ボタンが押されたことを反映

    // SnackBarの表示
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('送信成功！ 結果表示まで5秒ほど待て'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height / 2 - 50),
      ),
    );

    sendToFlask(_textController.text, _selectedUser);

    // ボタンのアニメーションのための一時的な遅延
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() => _isButtonPressed = false);
    });
  }

  Future<void> sendToFlask(String inputText, String userId) async {
    // const String apiUrl = "http://127.0.0.1:5000/analyze"; // ローカル
    const String apiUrl = "https://flask-v9rl.onrender.com/analyze"; // FlasK

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"text": inputText, "user_id": userId}),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        _classificationResult = result['analysis'];
      });
      debugPrint("感情分類結果: $_classificationResult");
    } else {
      debugPrint("APIエラー: ${response.statusCode}");
      setState(() => _isButtonPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // ユーザーID選択用のラジオボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: "mama",
                groupValue: _selectedUser,
                onChanged: (String? value) {
                  setState(() {
                    _selectedUser = value ?? "mama";
                  });
                },
              ),
              const Text('まま'),
              Radio<String>(
                value: "papa",
                groupValue: _selectedUser,
                onChanged: (String? value) {
                  setState(() {
                    _selectedUser = value ?? "mama";
                  });
                },
              ),
              const Text('ぱぱ'),
              Radio<String>(
                value: "haru",
                groupValue: _selectedUser,
                onChanged: (String? value) {
                  setState(() {
                    _selectedUser = value ?? "mama";
                  });
                },
              ),
              const Text('はる'),
              Radio<String>(
                value: "yume",
                groupValue: _selectedUser,
                onChanged: (String? value) {
                  setState(() {
                    _selectedUser = value ?? "mama";
                  });
                },
              ),
              const Text('ゆめ'),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextField(
                  controller: _textController,
                  minLines: null, // 初期の高さ
                  maxLines: null, // maxLinesをnullに設定して無制限に拡大
                  // expands: true,
                  scrollPhysics: const BouncingScrollPhysics(),
                  focusNode: _focusNode,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "今頭の中にあることを書く。\n余裕があれば【問題 →（希望/理想＆感情）←行動】を書く",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedScale(
            scale: _isButtonPressed ? 0.9 : 1.0, // ボタンが押されたら縮小
            duration: const Duration(milliseconds: 100),
            child: ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('そうしん'),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            constraints: const BoxConstraints(
              maxWidth: double.infinity, // 画面横いっぱい
            ),
            child: Text(
              '感情分類結果: $_classificationResult',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.left, // テキストを左揃えに
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
