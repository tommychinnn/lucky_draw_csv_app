import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async' show Timer;
import '../services/audio_service.dart';
import 'fireworks_widget.dart';

class AnimatedDrawWidget extends StatefulWidget {
  final List<String> participants;
  final Function(String, String) onWinnerSelected;
  final Duration animationDuration;
  final String prizeDescription;

  const AnimatedDrawWidget({
    super.key,
    required this.participants,
    required this.onWinnerSelected,
    required this.prizeDescription,
    this.animationDuration = const Duration(seconds: 5),
  });

  @override
  State<AnimatedDrawWidget> createState() => _AnimatedDrawWidgetState();
}

class _AnimatedDrawWidgetState extends State<AnimatedDrawWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? selectedWinner;
  bool isAnimating = false;
  String displayName = '';
  Timer? _timer;
  final AudioService _audioService = AudioService();
  bool isMuted = false;
  bool _showFireworks = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _controller.addStatusListener(_handleAnimationStatus);
    _audioService.initialize();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _timer?.cancel();
      if (!isMuted) {
        _audioService.stopSpinningSound().then((_) async {
          await Future.delayed(const Duration(milliseconds: 100));
          await _audioService.playWinnerSound();
        });
      }
      setState(() {
        isAnimating = false;
        displayName = selectedWinner!;
        _showFireworks = true;
        widget.onWinnerSelected(selectedWinner!, widget.prizeDescription);
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showFireworks = false;
          });
        }
      });
    }
  }

  void startDraw() {
    if (isAnimating) return;

    _audioService.stopWinnerSound();

    final random = math.Random();
    selectedWinner = widget.participants[random.nextInt(widget.participants.length)];

    setState(() {
      isAnimating = true;
      displayName = widget.participants[random.nextInt(widget.participants.length)];
    });

    if (!isMuted) {
      _audioService.startSpinningSound();
    }

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!isAnimating) return;
      setState(() {
        displayName = widget.participants[random.nextInt(widget.participants.length)];
      });
    });

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.prizeDescription,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE31837),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isMuted ? Icons.volume_off : Icons.volume_up,
                    color: const Color(0xFFE31837),
                  ),
                  onPressed: () {
                    setState(() {
                      isMuted = !isMuted;
                    });
                  },
                ),
              ],
            ),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFE31837),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(15),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFDF1DB),
                    Colors.white,
                    Color(0xFFFDF1DB),
                  ],
                ),
              ),
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: !isAnimating && selectedWinner != null
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: !isAnimating && selectedWinner != null
                        ? const Color(0xFFE31837)
                        : Colors.black87,
                  ),
                  child: Text(displayName),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: isAnimating ? null : startDraw,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31837),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: Icon(isAnimating ? Icons.hourglass_full : Icons.casino),
              label: Text(
                isAnimating ? '抽奖中... Drawing...' : '抽奖 Draw',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        if (_showFireworks)
          const Positioned.fill(
            child: FireworksWidget(),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _audioService.dispose();
    super.dispose();
  }
} 