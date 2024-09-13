import 'package:flutter/material.dart';
import 'package:myapp/pages/task_monster.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _currentIndex = 0; // デフォルトでHomePageを表示

  // ページのリスト
  final List<Widget> _pages = [
    const HomePage(),
    const TaskMonster(),
  ];

  // ページを切り替える関数
  void _onMenuTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 現在のページを表示
      body: SafeArea(
        child: Column(
          children: [
            // ナビゲーションバー
            Container(
              height: 60.0, // ナビゲーションバーの高さ
              // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              // padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // HomePageへのボタン
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: _currentIndex == 0 ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => _onMenuTap(0),
                    tooltip: 'Home',
                  ),
                  // TaskMonsterへのボタン
                  IconButton(
                    icon: Image.asset(
                      'assets/shoggoth.png',
                      width: 36,
                      height: 48,
                      color: _currentIndex == 1 ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => _onMenuTap(1),
                    tooltip: 'おばけ',
                  ),
                ],
              ),
            ),
            Expanded(
              child: _pages[_currentIndex],
            ),
          ],
        ),
      ),
    );
  }
}
