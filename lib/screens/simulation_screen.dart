import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../models/simulation_state.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SimulationState>(
      builder: (context, state, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            // Dynamic Zoom: Use maxHeightReached to determine scale
            // Ensure we always show at least the initial height or 100m
            final double viewHeight =
                max(state.maxHeightReached, state.initialHeight) + 20;

            final double pixelsPerMeter =
                (constraints.maxHeight - 100) /
                viewHeight; // -100 for ground buffer

            // Calculate ball position in pixels (from bottom)
            final double bottomPosition =
                (state.currentHeight * pixelsPerMeter) +
                50; // +50 for ground height

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.lightBlue.shade100, Colors.white],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: Stack(
                children: [
                  // Background Grid/Ruler
                  Positioned.fill(
                    child: CustomPaint(
                      painter: RulerPainter(viewHeight, pixelsPerMeter),
                    ),
                  ),

                  // Ground
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade400,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(14),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Suelo (y=0)',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Falling Object
                  Positioned(
                    bottom: bottomPosition,
                    left: constraints.maxWidth / 2 - 20, // Center horizontally
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.sports_soccer,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),

                  // Info Panel Overlay
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Card(
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tiempo: ${state.currentTime.toStringAsFixed(2)} s',
                            ),
                            Text(
                              'Altura: ${state.currentHeight.toStringAsFixed(2)} m',
                            ),
                            Text(
                              'Velocidad: ${state.currentVelocity.abs().toStringAsFixed(2)} m/s',
                            ),
                            if (state.airResistanceEnabled)
                              Text(
                                'Resistencia: ON',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class RulerPainter extends CustomPainter {
  final double maxHeight;
  final double pixelsPerMeter;

  RulerPainter(this.maxHeight, this.pixelsPerMeter);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.5)
      ..strokeWidth = 1;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // Determine grid step based on height to avoid clutter
    int step = 10;
    if (maxHeight > 500) step = 50;
    if (maxHeight > 2000) step = 200;

    // Draw lines
    for (int i = 0; i <= maxHeight; i += step) {
      final y = size.height - 50 - (i * pixelsPerMeter); // 50 is ground height
      if (y < 0) break;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);

      textPainter.text = TextSpan(
        text: '${i}m',
        style: TextStyle(color: Colors.grey, fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, y - 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; // Repaint when zoom changes
}
