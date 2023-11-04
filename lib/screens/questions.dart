import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qismat/screens/questiontype/dropdown_question.dart';
import 'package:qismat/screens/questiontype/checkbox_question.dart';
import 'package:qismat/screens/questiontype/doubleslider_question.dart';
import 'package:qismat/screens/questiontype/multiselect_dropdown_question.dart';
import 'package:qismat/screens/questiontype/text_question.dart';
import 'package:qismat/screens/questiontype/radio_question.dart';
import 'package:qismat/screens/questiontype/slider_question.dart';
import 'package:qismat/screens/questiontype/dateselect_question.dart';

class QuestionPage extends StatelessWidget {
  final Map<String, dynamic> questionData;
  final Function(String, dynamic) onSave;

  QuestionPage({
    required this.questionData,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    String type = questionData['type'];
    String question = questionData['question'];
    List<String>? options =
        (questionData['options'] as List<dynamic>?)?.cast<String>();

    Widget questionWidget;

    switch (type) {
      case "text":
        questionWidget = TextQuestionWidget(onSave: onSave, question: question);
        break;
      case "radio":
        questionWidget = RadioQuestionWidget(
            options: options!, onSave: onSave, question: question);
        break;
      case "double_slider":
        questionWidget = DoubleSliderQuestionWidget(
          onSave: onSave,
          question: question,
          minValue: double.parse(questionData['min'].toString()),
          maxValue: double.parse(questionData['max'].toString()),
        );
        break;
      case "slider":
        questionWidget = SliderQuestionWidget(
          onSave: onSave,
          question: question,
          minValue: double.parse(questionData['min'].toString()),
          maxValue: double.parse(questionData['max'].toString()),
        );
        break;
      case "dropdown":
        questionWidget = DropdownQuestionWidget(
            options: options!, onSave: onSave, question: question);
        break;
      case "multi_select_dropdown":
        questionWidget = MultiSelectDropdownQuestionWidget(
            options: options!, onSave: onSave, question: question);
        break;
      case "checkboxes":
        questionWidget = CheckboxesQuestionWidget(
            options: options!, onSave: onSave, question: question);
        break;
      case "date_select":
        questionWidget = DateSelectionQuestionWidget(
          onSave: onSave,
          question: question,
        );
        break;

      // Add handling for other question types here

      default:
        questionWidget = Container();
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(question)),
            SizedBox(height: 16),
            Center(child: questionWidget),
          ],
        ),
      ),
    );
  }
}
