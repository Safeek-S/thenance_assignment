import 'package:flutter/material.dart';

class CustomSlider extends StatelessWidget {
  final double currentPosition;
  final double totalDuration;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    Key? key,
    required this.currentPosition,
    required this.totalDuration,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 100,
        trackShape: const RectangularSliderTrackShape(),
        overlayShape: SliderComponentShape.noOverlay,
        thumbShape: SliderComponentShape.noThumb,
      ),
      child: Slider(
        min: 0,
        max: totalDuration,
        activeColor: const Color(0xffDFE2EA),
        inactiveColor: Colors.white,
        value: currentPosition,
        onChanged: onChanged,
      ),
    );
  }
}