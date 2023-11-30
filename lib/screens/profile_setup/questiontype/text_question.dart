import 'package:flutter/material.dart';

class TextQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final String field;

  const TextQuestionWidget({
    required this.onSave,
    required this.question,
    required this.field,
  });

  @override
  _TextQuestionWidgetState createState() => _TextQuestionWidgetState();
}

class _TextQuestionWidgetState extends State<TextQuestionWidget> {
  TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _textController,
          decoration: const InputDecoration(
            labelStyle: TextStyle(
                color: Color(
                    0xFFFF5858)), // Set the color of the email address string
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(
                      0xFFFF5858)), // Set the color of the focused text box border
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color(
                      0xFFFF5858)), // Set the color of the enabled (idle) text box border
            ),
          ),
          cursorColor: const Color(0xFFFF5858),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5858),
            ),
            child: const Text("Next", style: TextStyle(color: Colors.white)),
            onPressed: () {
              final answer = _textController.text;
              widget.onSave(widget.question, widget.field, answer);
            }),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
