import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelectDropdownQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final List<String> options;
  final String field;

  const MultiSelectDropdownQuestionWidget({
    required this.onSave,
    required this.question,
    required this.options,
    required this.field,
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
          selectedItemsTextStyle: const TextStyle(color: Colors.black),
          backgroundColor: const Color(0xFFFFDEDE),
          unselectedColor: Colors.white,
          selectedColor: const Color(0xFFFF7A7A),
          checkColor: const Color(0xFFFF5858),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5858),
            ),
            child: const Text("Next", style: TextStyle(color: Colors.white)),
            onPressed: () {
              widget.onSave(widget.question, widget.field, selectedOptions);
            },
          ),
        ),
      ],
    );
  }
}
