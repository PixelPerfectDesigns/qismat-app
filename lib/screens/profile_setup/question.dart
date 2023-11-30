import 'package:flutter/material.dart';
import 'package:qismat/screens/profile_setup/questiontype/dropdown_question.dart';
import 'package:qismat/screens/profile_setup/questiontype/checkbox_question.dart';
import 'package:qismat/screens/profile_setup/questiontype/doubleslider_question.dart';
import 'package:qismat/screens/profile_setup/questiontype/file_upload_question.dart';
import 'package:qismat/screens/profile_setup/questiontype/multiselect_dropdown_question.dart';
import 'package:qismat/screens/profile_setup/questiontype/text_question.dart';
import 'package:qismat/screens/profile_setup/questiontype/radio_question.dart';
import 'package:qismat/screens/profile_setup/questiontype/slider_question.dart';
import 'package:qismat/screens/profile_setup/questiontype/dateselect_question.dart';

class QuestionPage extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final Function(String, String, dynamic) onSave;

  QuestionPage({
    required this.questionData,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    String type = questionData['type'];
    String question = questionData['question'];
    String field = questionData['field'];
    List<String>? options =
        (questionData['options'] as List<dynamic>?)?.cast<String>();

    Widget questionWidget;

    switch (type) {
      case "text":
        questionWidget = TextQuestionWidget(
            onSave: onSave, question: question, field: field);
        break;
      case "radio":
        questionWidget = RadioQuestionWidget(
          options: options!,
          onSave: onSave,
          question: question,
          field: field,
        );
        break;
      case "double_slider":
        questionWidget = DoubleSliderQuestionWidget(
          onSave: onSave,
          question: question,
          minValue: double.parse(questionData['min'].toString()),
          maxValue: double.parse(questionData['max'].toString()),
          field: field,
        );
        break;
      case "slider":
        questionWidget = SliderQuestionWidget(
          onSave: onSave,
          question: question,
          minValue: double.parse(questionData['min'].toString()),
          maxValue: double.parse(questionData['max'].toString()),
          field: field,
        );
        break;
      case "dropdown":
        questionWidget = DropdownQuestionWidget(
            options: options!,
            onSave: onSave,
            question: question,
            field: field);
        break;
      case "multi_select_dropdown":
        questionWidget = MultiSelectDropdownQuestionWidget(
            options: options!,
            onSave: onSave,
            question: question,
            field: field);
        break;
      case "checkboxes":
        questionWidget = CheckboxesQuestionWidget(
            options: options!,
            onSave: onSave,
            question: question,
            field: field);
        break;
      case "date_select":
        questionWidget = DateSelectionQuestionWidget(
          onSave: onSave,
          question: question,
          field: field,
        );
        break;
      case "file_upload":
        questionWidget = FileUploadWidget(
          onSave: onSave,
          question: question,
          field: field,
        );
        break;
      // Add handling for other question types here

      default:
        questionWidget = Container();
    }

    return Padding(
      padding: const EdgeInsets.all(50),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                question,
                textAlign: TextAlign.center, // Center the text
                style: const TextStyle(
                  fontSize: 24, // Set the desired font size
                  fontWeight: FontWeight.bold, // Optional: Set the font weight
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: questionWidget),
          ],
        ),
      ),
    );
  }
}
