import 'package:flutter/material.dart';

class DoubleSliderQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final double minValue; // Add minValue property
  final double maxValue; // Add maxValue property
  final String field;

  DoubleSliderQuestionWidget({
    required this.onSave,
    required this.question,
    required this.minValue,
    required this.maxValue,
    required this.field,
  });

  @override
  _DoubleSliderQuestionWidgetState createState() =>
      _DoubleSliderQuestionWidgetState();
}

class _DoubleSliderQuestionWidgetState
    extends State<DoubleSliderQuestionWidget> {
  double _minSliderValue = 0.0;
  double _maxSliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    // Set an initial value within the specified range.
    _minSliderValue = (widget.minValue + widget.maxValue) / 3.0;
    _maxSliderValue = (widget.minValue + widget.maxValue) / 2.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          value: _minSliderValue,
          min: widget.minValue,
          max: widget.maxValue,
          activeColor: Color(0xFFFF5858),
          inactiveColor: Color(0xFFFFE1E1),
          onChanged: (value) {
            setState(() {
              _minSliderValue = value;
            });
          },
        ),
        Text("Min: ${_minSliderValue.toStringAsFixed(0)}"),
        Slider(
          value: _maxSliderValue,
          min: widget.minValue,
          max: widget.maxValue,
          activeColor: Color(0xFFFF5858),
          inactiveColor: Color(0xFFFFE1E1),
          onChanged: (value) {
            setState(() {
              _maxSliderValue = value;
            });
          },
        ),
        Text("Max: ${_maxSliderValue.toStringAsFixed(0)}"),
        SizedBox(height: 16),
        ElevatedButton(
            onPressed: () {
              widget.onSave(widget.question, widget.field,
                  {"min": _minSliderValue, "max": _maxSliderValue});
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF5858),
            ),
            child: Text("Next", style: TextStyle(color: Colors.white))),
      ],
    );
  }
}
