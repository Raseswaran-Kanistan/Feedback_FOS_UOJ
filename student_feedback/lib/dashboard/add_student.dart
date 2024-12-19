import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_feedback/screens/register_page.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddStudentPage extends StatefulWidget {
  final Function(String studentId, Map<String, dynamic> studentData)
      onAddStudent;
  final String courseId;
  final String courseType;

  const AddStudentPage({
    super.key,
    required this.onAddStudent,
    required this.courseId,
    required this.courseType,
  });

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController studentIdController = TextEditingController();

  void addStudent() async {
    if (studentIdController.text.isNotEmpty) {
      final supabase = Supabase.instance.client;

      // final student =
      //     await supabase.from('users').select().eq('id', studentId).single();
      final student = await supabase
          .from('users')
          .select()
          .eq('id', studentIdController.text.trim())
          .limit(1)
          .maybeSingle();

      if (student == null) {
        showMessage(context, 'Student not found. Enter a valid student ID.');
        return;
      }

      if (student['role'] != 'student') {
        showMessage(context,
            'You can\'t add ${isFirstCharVowel(student['role']) ? 'an' : 'a'} ${student['role']} as a student.');
        return;
      }

      final isRowExist = await supabase
          .from('student_course')
          .select()
          .eq('student', studentIdController.text.trim())
          .eq('course', widget.courseId)
          .eq('course_type', widget.courseType)
          .limit(1)
          .maybeSingle()
          .catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });

      if (isRowExist != null) {
        showMessage(context, 'The student is already enrolled in this course!');
      }

      await supabase.from('student_course').insert({
        'student': studentIdController.text.trim(),
        'course': widget.courseId,
        'course_type': widget.courseType.toLowerCase()
      });

      showMessage(context, 'Student added successfully!');
      studentIdController.clear();

      // Call the onAddStudent callback to add student
      widget.onAddStudent(studentIdController.text, student);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Student ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: studentIdController,
              decoration: const InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF731C65)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CustomElevatedButton(
              message: 'Add Student',
              function: addStudent,
              width: 500,
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF731C65)),
                minimumSize: const Size(double.infinity, 47),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Close',
                  style: TextStyle(color: Color(0xFF731C65))),
            ),
          ],
        ),
      ),
    );
  }
}
