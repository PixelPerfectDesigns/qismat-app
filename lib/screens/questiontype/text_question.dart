import 'package:flutter/material.dart';

class TextQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final String field;

  TextQuestionWidget({
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
          decoration: InputDecoration(labelText: 'Your Answer'),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF5858),
            ),
            child: Text("Next", style: TextStyle(color: Colors.white)),
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
