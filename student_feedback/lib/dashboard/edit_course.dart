import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/components/back_button.dart';
import 'package:student_feedback/screens/register_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditCoursePage extends StatefulWidget {
  final Map<String, dynamic> course;
  final Function(String, String, String) onEditCourse;

  EditCoursePage({required this.course, required this.onEditCourse});

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  late TextEditingController courseIdController;
  late TextEditingController courseNameController;
  String? selectedCourseType;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    courseIdController = TextEditingController(text: widget.course['id']);
    courseNameController = TextEditingController(text: widget.course['name']);
    selectedCourseType = widget.course['type'][0].toUpperCase() +
        widget.course['type'].substring(1);
  }

  void updateCourse() async {
    // Validation: Check if any field is empty
    if (courseIdController.text.isEmpty) {
      showError('Please enter a Course ID');
      return;
    }
    if (courseNameController.text.isEmpty) {
      showError('Please enter a Course Name');
      return;
    }
    if (selectedCourseType == null || selectedCourseType!.isEmpty) {
      showError('Please select a Course Type');
      return;
    }

    await supabase.from('courses').update({
      'id': courseIdController.text,
      'name': courseNameController.text,
      // 'type': selectedCourseType!.toLowerCase(),
    }).eq('id', widget.course['id']);

    widget.onEditCourse(
      courseIdController.text,
      courseNameController.text,
      selectedCourseType!,
    );

    Navigator.of(context).pop();
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBackButton(),
              const Gap(24),
              const Text(
                'Edit Course',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: courseIdController,
                decoration: const InputDecoration(
                  labelText: 'Course ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: courseNameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCourseType,
                decoration: const InputDecoration(labelText: 'Course Type'),
                items: <String>['Theory', 'Practical', 'Both']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCourseType = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Spacer(),
              CustomElevatedButton(
                message: 'Update Course',
                function: updateCourse,
                width: 500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
