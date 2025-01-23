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
    
    // Initialize one at a time for better reliability
    await _slotMachinePlayer.setAsset('assets/audio/slot_machine.mp4');
    await _slotMachinePlayer.setVolume(0.5);
    await _slotMachinePlayer.setLoopMode(LoopMode.one);  // Add loop mode back
    
    await _winnerPlayer.setAsset('assets/audio/winner.mp4');
    await _winnerPlayer.setVolume(1.0);  // Increase volume for winner sound
    
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
      // Increase delay before winner sound
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print('Error stopping spinning sound: $e');
    }
  }

  Future<void> playWinnerSound() async {
    try {
      // Make sure previous sound is completely stopped
      await _slotMachinePlayer.stop();
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Reset and play winner sound
      await _winnerPlayer.seek(Duration.zero);
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
    _slotMachinePlayer.dispose();
    _winnerPlayer.dispose();
  }
} 