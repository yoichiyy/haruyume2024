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

  // Hugging Face APIを呼び出す関数
  Future<void> sendToHuggingFace(String inputText) async {
    const String apiUrl =
        "https://api-inference.huggingface.co/models/your-model-name"; // Hugging FaceのモデルURL
    const String apiKey = "your-api-key"; // APIキーを設定

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"inputs": inputText}),
    );

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      debugPrint("感情分類結果: $result");
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
          const SizedBox(height: 20), // 上のウィジェットとのスペース（20px）
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
          const SizedBox(height: 20), // テキストエリアとボタンの間のスペース
          ElevatedButton(
            onPressed: () {
              sendToHuggingFace(_textController.text); // 送信ボタン押下時にAPIを呼び出す
            },
            child: const Text('送信'),
          ),
        ],
      ),
    );
  }
}
