import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyCupertinoApp());
}

class MyCupertinoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Медиа Демо',
      home: MediaPage(),
    );
  }
}

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.network(
      'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
    )..initialize().then((_) {
      setState(() {});
      _videoController.setLooping(true);
      _videoController.play();
    });

    _audioPlayer = AudioPlayer();
    _audioPlayer.setUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Медиа 🎧🎥'),
      ),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text("🎥 Видео плеер:"),
            if (_videoController.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              ),
            SizedBox(height: 20),
            CupertinoButton(
              child: Text(_videoController.value.isPlaying ? '⏸️ Пауза' : '▶️ Воспроизвести'),
              onPressed: () {
                setState(() {
                  _videoController.value.isPlaying
                      ? _videoController.pause()
                      : _videoController.play();
                });
              },
            ),
            Divider(),
            Text("🎧 Аудио плеер:"),
            CupertinoButton.filled(
              child: Text("▶️ Играть звук"),
              onPressed: () => _audioPlayer.play(),
            ),
            CupertinoButton(
              child: Text("⏸️ Пауза"),
              onPressed: () => _audioPlayer.pause(),
            ),
            CupertinoButton(
              child: Text("⏹️ Остановить"),
              onPressed: () => _audioPlayer.stop(),
            ),
          ],
        ),
      ),
    );
  }
}
