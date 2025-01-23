import 'package:just_audio/just_audio.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late AudioPlayer _slotMachinePlayer;
  late AudioPlayer _winnerPlayer;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _slotMachinePlayer = AudioPlayer();
    _winnerPlayer = AudioPlayer();
    
    // Preload both audio files
    await Future.wait([
      _slotMachinePlayer.setAsset('assets/audio/slot_machine.mp4'),
      _winnerPlayer.setAsset('assets/audio/winner.mp4'),
    ]);

    // Set up winner player with lower volume
    await _winnerPlayer.setVolume(0.8);
    
    _isInitialized = true;
  }

  Future<void> startSpinningSound() async {
    try {
      await _slotMachinePlayer.seek(Duration.zero);
      await _slotMachinePlayer.play();
    } catch (e) {
      print('Error playing spinning sound: $e');
    }
  }

  Future<void> stopSpinningSound() async {
    try {
      await _slotMachinePlayer.stop();
      // Add a small delay before playing winner sound
      await Future.delayed(const Duration(milliseconds: 300));
    } catch (e) {
      print('Error stopping spinning sound: $e');
    }
  }

  Future<void> playWinnerSound() async {
    try {
      await _winnerPlayer.seek(Duration.zero);
      await _winnerPlayer.play();
    } catch (e) {
      print('Error playing winner sound: $e');
    }
  }

  Future<void> stopWinnerSound() async {
    try {
      await _winnerPlayer.stop();
    } catch (e) {
      print('Error stopping winner sound: $e');
    }
  }

  void dispose() {
    _slotMachinePlayer.dispose();
    _winnerPlayer.dispose();
  }
} 