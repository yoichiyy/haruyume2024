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
    const String apiUrl = "http://192.168.11.36:5000/analyze"; // FlaskのURL
    // const String apiUrl =  "https://flask-v9rl.onrender.com/analyze"; // FlaskのURL

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
        _classificationResult = result['classification']; // 結果を保存
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
            child: const Text('送信'),
          ),
          const SizedBox(height: 20), // 結果表示のためのスペース
          Text(
            '感情分類結果: $_classificationResult',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
