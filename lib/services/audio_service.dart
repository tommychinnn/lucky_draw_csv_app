import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  AudioPlayer? _combinedPlayer;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  Future<void> startSpinningSound() async {
    try {
      // Dispose old player if exists
      _combinedPlayer?.dispose();
      
      // Create new player instance for each play
      _combinedPlayer = AudioPlayer();
      await _combinedPlayer!.setAsset('assets/audio/combine_slotmachine_winner.mp4');
      await _combinedPlayer!.play();
    } catch (e) {
      print('Error playing combined sound: $e');
    }
  }

  Future<void> stopSpinningSound() async {
    // No need to stop, let it continue to winner sound
  }

  Future<void> playWinnerSound() async {
    // Winner sound is part of combined audio now
  }

  Future<void> stopWinnerSound() async {
    try {
      await _combinedPlayer?.stop();
      await _combinedPlayer?.seek(Duration.zero);
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  void dispose() {
    _combinedPlayer?.dispose();
    _combinedPlayer = null;
  }
}