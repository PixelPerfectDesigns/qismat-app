import 'package:flutter/material.dart';

class RadioQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final List<String> options;
  final String field;

  RadioQuestionWidget({
    required this.onSave,
    required this.question,
    required this.options,
    required this.field,
  });

  @override
  _RadioQuestionWidgetState createState() => _RadioQuestionWidgetState();
}

class _RadioQuestionWidgetState extends State<RadioQuestionWidget> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: widget.options.map((option) {
            return RadioListTile(
              title: Text(option),
              value: option,
              groupValue: _selectedOption,
              onChanged: (value) {
                setState(() {
                  _selectedOption = value;
                });
              },
              activeColor: Color(0xFFFF5858),
            );
          }).toList(),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF5858),
          ),
          child: Text("Next", style: TextStyle(color: Colors.white)),
          onPressed: () {
            widget.onSave(widget.question, widget.field, _selectedOption);
          },
        ),
      ],
    );
  }
}
