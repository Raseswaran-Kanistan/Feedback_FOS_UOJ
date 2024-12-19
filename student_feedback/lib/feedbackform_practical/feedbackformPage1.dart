import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage2.dart';
import 'package:student_feedback/utils/utils.dart';
import '../router/router.dart';

class practicalPage1 extends StatefulWidget {
  const practicalPage1({
    super.key,
    required this.courseID,
    required this.courseName,
    required this.courseType,
  });

  final String courseID;
  final String courseName;
  final String courseType;

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<practicalPage1> {
  TextEditingController departmentController = TextEditingController();
  TextEditingController courseDetailController = TextEditingController();

  @override
  void initState() {
    courseDetailController.text = '${widget.courseID} - ${widget.courseName}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF731C65),
        title: const Text(
          'Student Evaluation Form ',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            final canPop = GoRouter.of(context).canPop();
            if (canPop) {
              GoRouter.of(context).pop();
            } else {
              // Optionally navigate to a default route if there's nothing to pop
              GoRouter.of(context)
                  .go('/StudentDashboard'); // Replace with your desired route
            }
          },
          icon: const Icon(
            CupertinoIcons.back,
            size: 35,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            const Text(
              'University of Jaffna',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Faculty of Science',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Student Evaluation Form - Practical',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Purpose: To get the feedback about the course unit and the teachers from the learners.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Scale: Five-point Likert scale ranging from Strongly Agree (5) to Strongly Disagree (1).',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Section A: Background Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: '1) Name of the Department',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Botany',
                  child: Text('Botany'),
                ),
                DropdownMenuItem(
                  value: 'Chemistry',
                  child: Text('Chemistry'),
                ),
                DropdownMenuItem(
                  value: 'Computer Science',
                  child: Text('Computer Science'),
                ),
                DropdownMenuItem(
                  value: 'Fisheries',
                  child: Text('Fisheries'),
                ),
                DropdownMenuItem(
                  value: 'Mathematics & Statistics',
                  child: Text('Mathematics & Statistics'),
                ),
                DropdownMenuItem(
                  value: 'Physics',
                  child: Text('Physics'),
                ),
                DropdownMenuItem(
                  value: 'Zoology',
                  child: Text(
                    'Zoology',
                  ),
                ),
              ],
              onChanged: (value) {
                departmentController.text = value.toString();
              },
            ),
            TextField(
              controller: courseDetailController,
              decoration: const InputDecoration(
                enabled: false,
                labelText: '2) Title of course unit and code',
              ),
            ),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: '3) Gender of the respondent (optional)',
              ),
              items: ['Male', 'Female', 'Other']
                  .map(
                    (gender) => DropdownMenuItem<String>(
                      value: gender,
                      child: Text(gender),
                    ),
                  )
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            const Text(
              'Using the Emojis:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('😠 '),
                    Text('Strongly Disagree', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('😟 '),
                    Text('Disagree', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('😐 '),
                    Text('Neutral', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('🙂 '),
                    Text('Agree', style: TextStyle(fontSize: 16)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('😃 '),
                    Text('Strongly Agree', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Please proceed to the next pages to rate your experience using these emojis.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  if (departmentController.text.isEmpty) {
                    showMessage(context, 'Please enter a department name');
                    return;
                  }
                  // GoRouter.of(context).go(Routers.feedbackformPage2.path, extra: {

                  // });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => practicalPage2(
                        formData: {
                          'department': departmentController.text,
                          'courseID': widget.courseID,
                          'courseType': widget.courseType,
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF731C65),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
