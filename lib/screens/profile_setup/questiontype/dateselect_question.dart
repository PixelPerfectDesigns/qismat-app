import 'package:flutter/material.dart';

class DateSelectionQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final String field;

  const DateSelectionQuestionWidget({
    required this.onSave,
    required this.question,
    required this.field,
  });

  @override
  _DateSelectionQuestionWidgetState createState() =>
      _DateSelectionQuestionWidgetState();
}

class _DateSelectionQuestionWidgetState
    extends State<DateSelectionQuestionWidget> {
  DateTime? selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(
                0xFFFF5858), // Change the color to your desired color
            colorScheme: const ColorScheme.light(
                primary: Color(
                    0xFFFF5858)), // Change the color to your desired color
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5858),
          ),
          onPressed: () => _selectDate(context),
          child: Text(
              "${selectedDate?.toLocal()}".split(' ')[0] ?? 'Select a date',
              style: const TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
            onPressed: () {
              if (selectedDate != null) {
                widget.onSave(widget.question, widget.field, selectedDate!);
              } else {
                // Handle the case where no date is selected
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5858),
            ),
            child: const Text("Next", style: TextStyle(color: Colors.white))),
      ],
    );
  }
}
