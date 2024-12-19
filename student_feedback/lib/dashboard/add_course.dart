import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_feedback/components/back_button.dart';
import 'package:student_feedback/screens/register_page.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({
    super.key,
    required this.onAddCourse,
    // required this.parentContext,
  });

  final Function(String, String, String) onAddCourse;
  // final BuildContext parentContext;

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final supabase = Supabase.instance.client;
  final TextEditingController courseIdController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();
  String selectedCourseType = 'Theory';

  void createCourse() async {
    // Validation: Check if any field is empty
    if (courseIdController.text.isEmpty) {
      showMessage(context, 'Please enter a Course ID');
      return;
    }
    if (courseNameController.text.isEmpty) {
      showMessage(context, 'Please enter a Course Name');
      return;
    }
    if (selectedCourseType.isEmpty) {
      showMessage(context, 'Please select a Course Type');
      return;
    }

    final courseData = {
      'id': courseIdController.text,
      'name': courseNameController.text,
      'type': selectedCourseType.toLowerCase(),
    };

    var existingCourse = await supabase
        .from('courses')
        .select('*')
        .eq('id', courseIdController.text)
        .maybeSingle();

    if (existingCourse != null) {
      if (existingCourse['type'] == 'both') {
        showMessage(context,
            'There is already a ${courseNameController.text} course with Theory & Practical type !');
        return;
      }

      if (existingCourse['type'] == selectedCourseType.toLowerCase()) {
        showMessage(context,
            'There is already a ${courseIdController.text} with $selectedCourseType type exists!');
        return;
      }

      if (selectedCourseType.toLowerCase() == 'both') {
        showMessage(context,
            'There is already a ${courseIdController.text} course exists, you can\'t set type as both!');
        return;
      }
    }

    Map data = {
      'id': courseIdController.text,
      'name': courseNameController.text,
      'type': selectedCourseType.toLowerCase(),
    };

    if (existingCourse != null) {
      data['type'] = 'both';
      await supabase
          .from('courses')
          .update(data)
          .eq('id', courseIdController.text);
    } else {
      await supabase.from('courses').insert(data);
    }

    var courses = await supabase
        .from('lecturer_course')
        .select('*')
        .eq('course', courseIdController.text);

    if (courses.isNotEmpty &&
        courses.toList().any((c) => c['course_type'] == 'both')) {
      showMessage(
        context,
        'This course ${courseIdController.text} has already been assigned to a lecturer!',
      );
    }

    if (courses.isNotEmpty &&
        courses
            .toList()
            .any((c) => c['course_type'] == selectedCourseType.toLowerCase())) {
      showMessage(
        context,
        'This course ${courseIdController.text} with $selectedCourseType has already been assigned to a lecturer!',
      );
    }

    Map<String, dynamic> userData = await getSession();

    if (courses.isNotEmpty &&
        courses.toList().any(
            (course) => course['lecturer'] == userData['userId'].toString())) {
      await supabase
          .from('lecturer_course')
          .update({
            'course_type': 'both',
          })
          .eq('course', courseIdController.text)
          .eq('lecturer', userData['userId'].toString());
    } else {
      await supabase.from('lecturer_course').insert({
        'lecturer': userData['userId'],
        'course': courseIdController.text,
        'course_type': selectedCourseType.toLowerCase(),
      });
    }

    // If all fields are valid, call the onAddCourse function
    widget.onAddCourse(
      courseIdController.text,
      courseNameController.text,
      selectedCourseType,
    );

    // Go back to the previous screen
    // showMessage(widget.parentContext, 'Course added successfully!');
    Navigator.pop(context);
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
              const Gap(16),
              const CustomBackButton(),
              const Gap(16),
              const Text(
                'Add Course',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(4),
              const Text(
                  'Enter the course ID and name to add a course, Use a unique identifier for your course.',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              TextField(
                controller: courseIdController,
                decoration: const InputDecoration(
                  labelText: 'Course ID',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF731C65)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: courseNameController,
                decoration: const InputDecoration(
                  labelText: 'Course Name',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBA68C8)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedCourseType,
                decoration: const InputDecoration(
                  labelText: 'Course Type',
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFBA68C8)),
                  ),
                ),
                items: <String>['Theory', 'Practical', 'Both']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCourseType = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Spacer(),
              CustomElevatedButton(
                width: 500,
                message: 'Create Course',
                function: createCourse,
              )
            ],
          ),
        ),
      ),
    );
  }
}
