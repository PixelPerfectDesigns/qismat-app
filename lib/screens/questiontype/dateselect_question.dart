import 'package:flutter/material.dart';

class DateSelectionQuestionWidget extends StatefulWidget {
  final Function(String, DateTime) onSave;
  final String question;

  DateSelectionQuestionWidget({
    required this.onSave,
    required this.question,
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
            primaryColor:
                Color(0xFFFF5858), // Change the color to your desired color
            colorScheme: ColorScheme.light(
                primary: Color(
                    0xFFFF5858)), // Change the color to your desired color
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
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
            backgroundColor: Color(0xFFFF5858),
          ),
          onPressed: () => _selectDate(context),
          child: Text(
              "${selectedDate?.toLocal()}".split(' ')[0] ?? 'Select a date',
              style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
            onPressed: () {
              if (selectedDate != null) {
                widget.onSave(widget.question, selectedDate!);
              } else {
                // Handle the case where no date is selected
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF5858),
            ),
            child: Text("Next", style: TextStyle(color: Colors.white))),
      ],
    );
  }
}
