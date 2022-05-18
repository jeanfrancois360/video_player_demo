import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerCustom extends StatefulWidget {
  const VideoPlayerCustom({Key? key}) : super(key: key);

  @override
  State<VideoPlayerCustom> createState() => _VideoPlayerCustomState();
}

class _VideoPlayerCustomState extends State<VideoPlayerCustom> {
  late VideoPlayerController _controller;
  late Future<void> _video;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4");
    _video = _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
              future: _video,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    rewind5Seconds();
                  },
                  child: const Icon(Icons.fast_rewind)),
              const Padding(padding: EdgeInsets.all(3)),
              ElevatedButton(
                  onPressed: () {
                    if (_controller.value.isPlaying) {
                      setState(
                        () => {_controller.pause()},
                      );
                    } else {
                      setState(
                        () => {_controller.play()},
                      );
                    }
                  },
                  child: Icon(_controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow)),
              const Padding(padding: EdgeInsets.all(3)),
              ElevatedButton(
                  onPressed: () {
                    forward5Seconds();
                  },
                  child: const Icon(Icons.fast_forward)),
              const Padding(padding: EdgeInsets.all(3)),
              ElevatedButton(
                  onPressed: () {
                    setState(
                      () => {_controller.pause()},
                    );
                  },
                  child: const Icon(Icons.stop)),
            ],
          )
        ],
      ),
    );
  }

  Future forward5Seconds() async =>
      goToPosition((currentPosition) => currentPosition + Duration(seconds: 5));

  Future rewind5Seconds() async =>
      goToPosition((currentPosition) => currentPosition - Duration(seconds: 5));

  Future goToPosition(
    Duration Function(Duration currentPosition) builder,
  ) async {
    final currentPosition = await _controller.position;
    final newPosition = builder(currentPosition!);

    await _controller.seekTo(newPosition);
  }
}
