import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // Required for File operations
import 'dart:html' as html; // For web-specific functionality (only for web)
import 'package:gallery_saver/gallery_saver.dart'; // Required for saving to gallery


class TaskMonster extends StatefulWidget {
  const TaskMonster({super.key});

  @override
  State<TaskMonster> createState() => _TaskMonsterState();
}

class _TaskMonsterState extends State<TaskMonster> {
  double _monsterSize = 150;
  int _tapCount = 0;
  late AudioPlayer _audioPlayer;
  bool taskComplete = false;
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeCamera();
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

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
      debugPrint('Camera initialized successfully');
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (_cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      String videoPath;
    // Check if the app is running on the web or mobile platforms
    if (kIsWeb) {
      // Handle web-specific functionality (no real file system access)
      videoPath =
          'web_video_path'; // Placeholder, web cannot save files like mobile
      debugPrint('Running on the web - saving video is not supported.');

      // Simulate video recording for the web (Blob URL handling)
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });

      // Stop the video recording and get the video file (blob URL)
      XFile videoFile = await _cameraController!.stopVideoRecording();
      final videoUrl = videoFile.path; // This is the Blob URL in web
      debugPrint('Video saved to $videoUrl');

      // Create a download link in the browser to save the video
      html.AnchorElement(href: videoUrl)
        ..setAttribute('download', 'video.mp4') // Set the file name for download
        ..click(); // Simulate a click to download the file

    } else {
      // For Android/iOS
      final directory = await getApplicationDocumentsDirectory();
      videoPath = '${directory.path}/video_${DateTime.now()}.mp4';

      // Start recording video
      await _cameraController!.startVideoRecording();
      setState(() {
        _isRecording = true;
      });

      debugPrint('Video recording started and will be saved to: $videoPath');

      // To stop recording:
      XFile videoFile = await _cameraController!.stopVideoRecording(); // Stop the recording
      videoPath = videoFile.path; // The recorded video file path
      debugPrint('Video saved to $videoPath');

      // Optionally save the video to the gallery (iOS/Android)
      await GallerySaver.saveVideo(videoPath);
      debugPrint('Video saved to the gallery.');
    }
  } catch (e) {
    debugPrint("ERROR: $e");
  }
}
  Future<void> _stopRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isRecordingVideo) {
      return;
    }

    try {
      final XFile videoFile = await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
      // 保存された動画のパス
      final String videoPath = videoFile.path;
      debugPrint('Video saved to $videoPath');
      // ユーザーに動画保存先を表示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Video saved to: $videoPath')),
      );
    } catch (e) {
      debugPrint("ERROR STOPPING VIDEO: $e");
    }
  }

  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.setSource(AssetSource('sword.mp3'));
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.resume();
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_cameraController != null &&
                  _cameraController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: CameraPreview(_cameraController!),
                )
              else
                const CircularProgressIndicator(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _toggleRecording,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isRecording)
                const Text(
                  '録画中...',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
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
      ),
    );
  }
}
