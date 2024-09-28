import 'package:audioplayers/audioplayers.dart';
// import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskMonster extends StatefulWidget {
  const TaskMonster({super.key});

  @override
  State<TaskMonster> createState() => _TaskMonsterState();
}

class _TaskMonsterState extends State<TaskMonster> {
  double _monsterSize = 150;
  int _tapCount = 0;
  late AudioPlayer? _audioPlayer;
  bool taskComplete = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void _handleTap() async {
    await _playSound();
    _updateImageSize();
  }

  void _updateImageSize() {
    setState(() {
      _tapCount++;
      if (_tapCount == 3) {
        _monsterSize = 0.0;
      } else {
        _monsterSize /= 1.5;
      }
    });
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer!.setSource(AssetSource('sword.mp3'));
      await _audioPlayer!.setVolume(1.0);
      await _audioPlayer!.resume();
      HapticFeedback.mediumImpact(); // バイブレーション
    } catch (e) {
      debugPrint("ERROR PLAYING SOUND: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: const BottomBar(currentIndex: 0),
      appBar: AppBar(
        title: const Text('やること'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _handleTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                width: _monsterSize,
                height: _monsterSize * 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Image.asset('assets/shoggoth.png'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
