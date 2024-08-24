import 'package:flutter/material.dart';

final class WavePainter extends CustomPainter {
  final List<double> waveformValues;
  final Color waveColor;
  final double strokeValue, verticalCenter;

  WavePainter({
    super.repaint,
    required this.waveformValues,
    required this.waveColor,
    required this.strokeValue,
    required this.verticalCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final brush = Paint()
      ..color = waveColor
      ..strokeWidth = strokeValue
      ..strokeCap = StrokeCap.round;
// The shift variable serves as the horizontal offset
    var shift = 0.0;

    for (var i = 0; i < waveformValues.length && shift < size.width; i++) {
      // This draws the line in canvas
      canvas.drawLine(Offset(shift, verticalCenter - waveformValues[i]),
          Offset(shift, verticalCenter + waveformValues[i]), brush);
      shift += 6;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
