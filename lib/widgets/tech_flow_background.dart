import 'dart:math' as math;
import 'package:flutter/material.dart';

class TechFlowBackground extends StatefulWidget {
  final Color baseColor;
  final Color accentColor;

  const TechFlowBackground({
    super.key,
    this.baseColor = const Color(0xFF1B4B66),
    this.accentColor = const Color(0xFF2D7D9A),
  });

  @override
  State<TechFlowBackground> createState() => _TechFlowBackgroundState();
}

class _TechFlowBackgroundState extends State<TechFlowBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> particles = [];
  final int numberOfParticles = 50;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Initialize particles
    final random = math.Random();
    for (int i = 0; i < numberOfParticles; i++) {
      particles.add(
        Particle(
          position: Offset(
            random.nextDouble(),
            random.nextDouble(),
          ),
          speed: 0.2 + random.nextDouble() * 0.3,
          size: 2 + random.nextDouble() * 3,
          direction: Offset(
            -0.5 + random.nextDouble(),
            -0.5 + random.nextDouble(),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: TechFlowPainter(
            particles: particles,
            progress: _controller.value,
            baseColor: widget.baseColor,
            accentColor: widget.accentColor,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  Offset position;
  final double speed;
  final double size;
  final Offset direction;

  Particle({
    required this.position,
    required this.speed,
    required this.size,
    required this.direction,
  });
}

class TechFlowPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color baseColor;
  final Color accentColor;

  TechFlowPainter({
    required this.particles,
    required this.progress,
    required this.baseColor,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Update and draw particles
    for (final particle in particles) {
      // Update position
      particle.position = Offset(
        (particle.position.dx + particle.direction.dx * particle.speed * 0.01) % 1.0,
        (particle.position.dy + particle.direction.dy * particle.speed * 0.01) % 1.0,
      );

      // Draw particle
      paint.color = Color.lerp(
        baseColor.withOpacity(0.3),
        accentColor.withOpacity(0.3),
        particle.speed * 2,
      )!;
      paint.strokeWidth = particle.size;

      final point = Offset(
        particle.position.dx * size.width,
        particle.position.dy * size.height,
      );

      // Draw line with fade effect
      final endPoint = Offset(
        point.dx + particle.direction.dx * 50,
        point.dy + particle.direction.dy * 50,
      );

      final gradient = LinearGradient(
        colors: [
          paint.color,
          paint.color.withOpacity(0),
        ],
      );

      paint.shader = gradient.createShader(
        Rect.fromPoints(point, endPoint),
      );

      canvas.drawLine(point, endPoint, paint);
    }

    // Draw connecting lines between nearby particles
    for (int i = 0; i < particles.length; i++) {
      final p1 = particles[i];
      final point1 = Offset(
        p1.position.dx * size.width,
        p1.position.dy * size.height,
      );

      for (int j = i + 1; j < particles.length; j++) {
        final p2 = particles[j];
        final point2 = Offset(
          p2.position.dx * size.width,
          p2.position.dy * size.height,
        );

        final distance = (point2 - point1).distance;
        if (distance < 100) {
          paint.shader = null;
          paint.strokeWidth = 1;
          paint.color = baseColor.withOpacity(0.1 * (1 - distance / 100));
          canvas.drawLine(point1, point2, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(TechFlowPainter oldDelegate) => true;
} 