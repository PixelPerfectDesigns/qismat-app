import 'package:flutter/material.dart';

class EmailWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final String field;

  const EmailWidget({
    required this.onSave,
    required this.question,
    required this.field,
  });

  @override
  _EmailWidgetState createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            labelStyle: TextStyle(
              color: Color(0xFFFF5858),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF5858),
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFF5858),
              ),
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
            final email = _emailController.text;
            widget.onSave(widget.question, widget.field, email);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
