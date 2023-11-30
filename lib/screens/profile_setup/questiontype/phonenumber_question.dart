import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final String field;

  const PhoneNumberWidget({
    required this.onSave,
    required this.question,
    required this.field,
  });

  @override
  _PhoneNumberWidgetState createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<PhoneNumberWidget> {
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10), // Limit to 10 digits
            // You can add more formatters for formatting the phone number as needed
          ],
          decoration: const InputDecoration(
            labelText: 'Phone Number',
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
            final phoneNumber = _phoneController.text;
            widget.onSave(widget.question, widget.field, phoneNumber);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
