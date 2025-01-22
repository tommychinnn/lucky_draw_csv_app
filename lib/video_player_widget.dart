import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  // ... (existing code)

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initializeVideo() async {
    try {
      await _controller.initialize();
      if (kIsWeb && _isSafari()) {
        // Use alternative video format or show fallback
      }
    } catch (e) {
      print('Video initialization error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(
      key: UniqueKey(),
      controller: _controller,
      onError: (error) {
        print('Video Error: $error');
        // Implement fallback or show error message
      },
    );
  }

  bool _isSafari() {
    // Implement the logic to check if the platform is Safari
    // This is a placeholder and should be replaced with the actual implementation
    return false;
  }
} 