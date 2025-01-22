String getVideoPath() {
  if (kIsWeb && _isSafari()) {
    return 'assets/winner_safari.mp4';
  }
  return 'assets/winner.mp4';
}

bool _isSafari() {
  // Add Safari detection logic
  return window.navigator.userAgent.toLowerCase().contains('safari') &&
         !window.navigator.userAgent.toLowerCase().contains('chrome');
} 