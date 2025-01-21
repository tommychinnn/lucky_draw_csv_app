import 'package:flutter/material.dart';
import 'dart:math' as math;

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  Color color;
  double size;
  double life;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    this.life = 1.0,
  });
}

class FireworksWidget extends StatefulWidget {
  final Duration duration;

  const FireworksWidget({
    super.key,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<FireworksWidget> createState() => _FireworksWidgetState();
}

class _FireworksWidgetState extends State<FireworksWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<List<Particle>> _fireworks = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addListener(_updateParticles);
    _createFireworks();
    _controller.forward();
  }

  void _createFireworks() {
    // Increase number of firework bursts
    for (int i = 0; i < 8; i++) {  // Increased from 5 to 8
      Future.delayed(Duration(milliseconds: i * 400), () {  // Reduced delay between bursts
        if (mounted) {
          _addFirework();
        }
      });
    }
  }

  void _addFirework() {
    final List<Particle> particles = [];
    // Adjust position range for better spread
    final double centerX = _random.nextDouble() * MediaQuery.of(context).size.width;
    final double centerY = _random.nextDouble() * MediaQuery.of(context).size.height * 0.7;

    // Increase number of particles per firework
    for (int i = 0; i < 80; i++) {  // Increased from 50 to 80
      final angle = _random.nextDouble() * 2 * math.pi;
      // Increase velocity range for bigger bursts
      final velocity = _random.nextDouble() * 3 + 3;  // Increased velocity
      final color = _getRandomColor();

      particles.add(Particle(
        x: centerX,
        y: centerY,
        vx: math.cos(angle) * velocity,
        vy: math.sin(angle) * velocity,
        color: color,
        size: _random.nextDouble() * 3 + 3,  // Increased particle size
      ));
    }

    // Add a second layer of particles for more density
    for (int i = 0; i < 40; i++) {
      final angle = _random.nextDouble() * 2 * math.pi;
      final velocity = _random.nextDouble() * 2 + 2;
      final color = _getRandomColor();

      particles.add(Particle(
        x: centerX,
        y: centerY,
        vx: math.cos(angle) * velocity,
        vy: math.sin(angle) * velocity,
        color: color,
        size: _random.nextDouble() * 2 + 1,
      ));
    }

    setState(() {
      _fireworks.add(particles);
    });
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xFFFF0000),  // Bright Red
      const Color(0xFFFFD700),  // Gold
      const Color(0xFFFF1493),  // Deep Pink
      const Color(0xFF00FF00),  // Bright Green
      const Color(0xFF00FFFF),  // Cyan
      const Color(0xFFFF4500),  // Orange Red
      const Color(0xFFFF69B4),  // Hot Pink
      const Color(0xFF4169E1),  // Royal Blue
      const Color(0xFFFFFF00),  // Yellow
      const Color(0xFFFFA500),  // Orange
    ];
    return colors[_random.nextInt(colors.length)];
  }

  void _updateParticles() {
    setState(() {
      for (var firework in _fireworks) {
        for (var particle in firework) {
          particle.x += particle.vx;
          particle.y += particle.vy;
          particle.vy += 0.08;  // Reduced gravity for slower fall
          particle.life *= 0.96;  // Slower fade out
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(
        painter: FireworksPainter(
          fireworks: _fireworks,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class FireworksPainter extends CustomPainter {
  final List<List<Particle>> fireworks;

  FireworksPainter({required this.fireworks});

  @override
  void paint(Canvas canvas, Size size) {
    for (var firework in fireworks) {
      for (var particle in firework) {
        if (particle.life > 0.1) {
          final paint = Paint()
            ..color = particle.color.withOpacity(particle.life)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);  // Added glow effect

          // Draw main particle
          canvas.drawCircle(
            Offset(particle.x, particle.y),
            particle.size * particle.life,
            paint,
          );

          // Draw glow
          paint.color = particle.color.withOpacity(particle.life * 0.5);
          canvas.drawCircle(
            Offset(particle.x, particle.y),
            particle.size * particle.life * 1.5,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(FireworksPainter oldDelegate) => true;
}