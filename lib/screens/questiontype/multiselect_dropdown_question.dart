import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelectDropdownQuestionWidget extends StatefulWidget {
  final Function(String, dynamic) onSave;
  final String question;
  final List<String> options;

  MultiSelectDropdownQuestionWidget({
    required this.onSave,
    required this.question,
    required this.options,
  });

  @override
  _MultiSelectDropdownQuestionWidgetState createState() =>
      _MultiSelectDropdownQuestionWidgetState();
}

class _MultiSelectDropdownQuestionWidgetState
    extends State<MultiSelectDropdownQuestionWidget> {
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MultiSelectDialogField(
          items: widget.options.map((option) {
            return MultiSelectItem(option, option);
          }).toList(),
          listType: MultiSelectListType.CHIP,
          onConfirm: (values) {
            setState(() {
              selectedOptions = values;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFF5858),
            ),
            child: Text("Next", style: TextStyle(color: Colors.white)),
            onPressed: () {
              widget.onSave(widget.question, selectedOptions);
            },
          ),
        ),
      ],
    );
  }
}
