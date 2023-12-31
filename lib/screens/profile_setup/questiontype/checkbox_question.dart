import 'package:flutter/material.dart';

class CheckboxesQuestionWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final List<String> options;
  final String field;

  const CheckboxesQuestionWidget({
    required this.onSave,
    required this.question,
    required this.options,
    required this.field,
  });

  @override
  _CheckboxesQuestionWidgetState createState() =>
      _CheckboxesQuestionWidgetState();
}

class _CheckboxesQuestionWidgetState extends State<CheckboxesQuestionWidget> {
  List<bool> selectedOptions = List.generate(0, (index) => false);

  @override
  void initState() {
    super.initState();
    // Set an initial value within the specified range.
    selectedOptions = List.generate(widget.options.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < widget.options.length; i++) ...[
          Row(
            children: [
              Checkbox(
                value: selectedOptions[i],
                onChanged: (value) {
                  setState(() {
                    selectedOptions[i] = value!;
                  });
                },
                activeColor: const Color(0xFFFF5858),
              ),
              Text(widget.options[i]),
            ],
          ),
        ],
        const SizedBox(height: 8.0),
        Center(
            child: ElevatedButton(
                onPressed: () {
                  final selectedValues = <String>[];
                  for (int i = 0; i < widget.options.length; i++) {
                    if (selectedOptions[i]) {
                      selectedValues.add(widget.options[i]);
                    }
                  }
                  widget.onSave(widget.question, widget.field, selectedValues);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5858),
                ),
                child: const Text("Next",
                    style: TextStyle(
                        color: Colors
                            .white)))) // Add some spacing between checkboxes and the button

        ,
      ],
    );
  }
}
