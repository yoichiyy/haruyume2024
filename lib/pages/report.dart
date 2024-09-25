import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StructuredReportPage extends StatefulWidget {
  final String userId;

  const StructuredReportPage({super.key, required this.userId});

  @override
  StructuredReportPageState createState() => StructuredReportPageState();
}

class StructuredReportPageState extends State<StructuredReportPage> {
  Map<String, dynamic>? report;
  Uint8List? pieChart;

  // レポート作成リクエスト
  Future<void> generateStructuredReport() async {
    final url =
        Uri.parse('https://flask-v9rl.onrender.com/generate_structured_report');

//debug1
    debugPrint('Sending request to $url');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': widget.userId}),
    );

    // ステータスコードを確認
    debugPrint('Response status: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        report = data;
        pieChart = base64Decode(data['pie_chart']);
      });
    } else {
      setState(() {
        report = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("構造化されたレポート"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: generateStructuredReport,
              child: const Text("レポート作成"),
            ),
            const SizedBox(height: 20),
            report != null
                ? Expanded(
                    child: ListView(
                      children: [
                        const Text("感情:"),
                        pieChart != null
                            ? Image.memory(pieChart!)
                            : const Text("感情円グラフがありません"),
                        const SizedBox(height: 20),
                        const Text("重要な出来事:"),
                        ...report!['important_events']
                            .map<Widget>((e) => Text(e)),
                        const SizedBox(height: 20),
                        const Text("Good:"),
                        ...report!['good_things'].map<Widget>((e) => Text(e)),
                        const SizedBox(height: 20),
                        const Text("Bad:"),
                        ...report!['bad_things'].map<Widget>((e) => Text(e)),
                        const SizedBox(height: 20),
                        const Text("強み:"),
                        ...report!['strengths'].map<Widget>((e) => Text(e)),
                        const SizedBox(height: 20),
                        const Text("弱み:"),
                        ...report!['weaknesses'].map<Widget>((e) => Text(e)),
                      ],
                    ),
                  )
                : const Text("レポートがここに表示されます。"),
          ],
        ),
      ),
    );
  }
}
