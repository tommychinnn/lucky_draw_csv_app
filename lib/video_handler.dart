import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class VideoHandler {
  static String getVideoPath(String videoType) {
    if (kIsWeb && _isSafari()) {
      // For Safari, try to play the video first
      if (videoType == 'winner') {
        return 'assets/audio/winner.mp4';
      }
    }
    // Default paths
    switch (videoType) {
      case 'winner':
        return 'assets/audio/winner.mp4';
      case 'slot_machine':
        return 'assets/audio/slot_machine.mp4';
      default:
        return 'assets/audio/slot_machine.mp4';
    }
  }

  static bool _isSafari() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('safari') && !userAgent.contains('chrome');
  }
} 