import 'package:flutter/material.dart';

class SliderQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final double minValue; // Add minValue property
  final double maxValue; // Add maxValue property
  final String field;

  const SliderQuestionWidget({
    required this.onSave,
    required this.question,
    required this.minValue,
    required this.maxValue,
    required this.field,
  });

  @override
  _SliderQuestionWidgetState createState() => _SliderQuestionWidgetState();
}

class _SliderQuestionWidgetState extends State<SliderQuestionWidget> {
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    // Set an initial value within the specified range.
    _sliderValue = (widget.minValue + widget.maxValue) / 2.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _sliderValue,
          min: widget.minValue,
          max: widget.maxValue,
          activeColor: const Color(0xFFFF5858),
          inactiveColor: const Color(0xFFFFE1E1),
          onChanged: (value) {
            setState(() {
              _sliderValue = value;
            });
          },
        ),
        Text("${_sliderValue.toStringAsFixed(0)}"),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5858),
          ),
          child: const Text("Next", style: TextStyle(color: Colors.white)),
          onPressed: () {
            widget.onSave(widget.question, widget.field, _sliderValue);
          },
        ),
      ],
    );
  }
}
