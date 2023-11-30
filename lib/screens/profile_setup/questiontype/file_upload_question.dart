import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FileUploadWidget extends StatefulWidget {
  final Function(String, String, dynamic) onSave;
  final String question;
  final String field;

  FileUploadWidget({
    required this.onSave,
    required this.question,
    required this.field,
  });

  @override
  _FileUploadWidgetState createState() => _FileUploadWidgetState();
}

class _FileUploadWidgetState extends State<FileUploadWidget> {
  String _filePath = ""; // Store the file path
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(
      bucket: 'gs://qismat-flutter-app.appspot.com');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF5858),
          ),
          child: Text("Upload File", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            String? filePath = await _pickFile();
            if (filePath != null) {
              setState(() {
                _filePath = filePath;
              });
            }
          },
        ),
        SizedBox(height: 16),
        Text("File Path: $_filePath"),
        SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF5858),
          ),
          child: Text("Next", style: TextStyle(color: Colors.white)),
          onPressed: () async {
            if (_filePath.isNotEmpty) {
              String downloadUrl = await _uploadFile();
              widget.onSave(widget.question, widget.field, downloadUrl);
            }
          },
        ),
      ],
    );
  }

  Future<String?> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        return result.files.single.path;
      } else {
        return null; // User canceled the picker
      }
    } catch (e) {
      print("Error picking file: $e");
      return null;
    }
  }

  Future<String> _uploadFile() async {
    try {
      File file = File(_filePath);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child('uploads/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);

      await uploadTask.whenComplete(() => print('File Uploaded'));
      String downloadUrl = await storageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print("Error uploading file: $e");
      throw e;
    }
  }
}
