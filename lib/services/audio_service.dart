import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _spinningPlayer = AudioPlayer();
  final AudioPlayer _winnerPlayer = AudioPlayer();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    try {
      await _spinningPlayer.setAsset('assets/audio/slot_machine.mp4');
      await _spinningPlayer.setLoopMode(LoopMode.one);
      await _spinningPlayer.setVolume(0.5);
      
      await _winnerPlayer.setAsset('assets/audio/winner.mp4');
      await _winnerPlayer.setVolume(0.7);
      
      _initialized = true;
    } catch (e) {
      print('Error initializing audio: $e');
    }
  }

  Future<void> startSpinningSound() async {
    try {
      await _spinningPlayer.seek(Duration.zero);
      await _spinningPlayer.play();
    } catch (e) {
      print('Error playing spinning sound: $e');
    }
  }

  Future<void> stopSpinningSound() async {
    try {
      await _spinningPlayer.stop();
      await _spinningPlayer.seek(Duration.zero);  // Reset position
    } catch (e) {
      print('Error stopping spinning sound: $e');
    }
  }

  Future<void> playWinnerSound() async {
    try {
      // Stop any previous playback
      await _winnerPlayer.stop();
      // Reset to beginning
      await _winnerPlayer.seek(Duration.zero);
      // Play the sound
      await _winnerPlayer.play();
    } catch (e) {
      print('Error playing winner sound: $e');
    }
  }

  Future<void> stopWinnerSound() async {
    try {
      await _winnerPlayer.stop();
      await _winnerPlayer.seek(Duration.zero);
    } catch (e) {
      print('Error stopping winner sound: $e');
    }
  }

  void dispose() {
    _spinningPlayer.dispose();
    _winnerPlayer.dispose();
  }
} 