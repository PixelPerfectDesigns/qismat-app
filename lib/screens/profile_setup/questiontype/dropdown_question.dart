import 'package:flutter/material.dart';

class DropdownQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final List<String> options;
  final String field;

  const DropdownQuestionWidget({
    required this.onSave,
    required this.question,
    required this.options,
    required this.field,
  });

  @override
  _DropdownQuestionWidgetState createState() => _DropdownQuestionWidgetState();
}

class _DropdownQuestionWidgetState extends State<DropdownQuestionWidget> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedOption,
          items: widget.options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedOption = value;
            });
          },
          style: const TextStyle(color: Colors.black),
          iconEnabledColor: const Color(0xFFFF5858),
          // dropdownColor: Color(0xFFFF5858), // Set the dropdown background color
// Set the dropdown icon color
          // Set the dropdown text color
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            onPressed: () {
              widget.onSave(widget.question, widget.field, selectedOption);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5858),
            ),
            child: const Text("Next", style: TextStyle(color: Colors.white))),
      ],
    );
  }
}
