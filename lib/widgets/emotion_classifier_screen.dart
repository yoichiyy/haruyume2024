import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;

class EmotionClassifierScreen extends StatefulWidget {
  const EmotionClassifierScreen({super.key});

  @override
  EmotionClassifierScreenState createState() => EmotionClassifierScreenState();
}

class EmotionClassifierScreenState extends State<EmotionClassifierScreen> {
  final TextEditingController _textController = TextEditingController();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  bool _isListening = false;
  String _classificationResult = ""; // 感情分類結果を表示

  // Flask APIを呼び出す関数
  Future<void> sendToFlask(String inputText) async {
    // const String apiUrl = "http://127.0.0.1:5000/analyze"; // ローカル
    const String apiUrl = "https://flask-v9rl.onrender.com/analyze"; // FlasK

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"text": inputText}), // テキストを送信
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      setState(() {
        _classificationResult = result['analysis']; // 結果を保存
      });
      debugPrint("感情分類結果: $_classificationResult");
    } else {
      debugPrint("APIエラー: ${response.statusCode}");
    }
  }

  // 音声入力を開始する関数
  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        });
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              SizedBox(
                height: 200, // 縦3cm (100px 近い)
                width: 500, // 横5cm (250px 近い)
                child: TextField(
                  controller: _textController,
                  maxLines: 20,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'テキストを入力してください',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.mic),
                onPressed: _listen, // 音声入力を開始
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              sendToFlask(_textController.text); // 送信ボタン押下時にAPIを呼び出す
            },
            child: const Text('そうしん'),
          ),
          const SizedBox(height: 20), // 結果表示のためのスペース
          Container(
            padding: const EdgeInsets.all(10.0), // 枠線内の余白
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0), // 左右の余白（1cm相当）
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0), // 黒い枠線
              borderRadius: BorderRadius.circular(5.0), // 角を少し丸める
            ),
            constraints: const BoxConstraints(
              maxWidth: double.infinity, // 画面横いっぱい
            ),
            child: Text(
              '感情分類結果: $_classificationResult',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.left, // テキストを左揃えに
            ),
          )
        ],
      ),
    );
  }
}
