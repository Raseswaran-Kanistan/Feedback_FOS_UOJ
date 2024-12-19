import 'package:flutter/material.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'feedbackformPage2.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';

class Page1 extends StatefulWidget {
  final String courseID;
  final String courseName;

  const Page1({super.key, required this.courseID, required this.courseName});

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  TextEditingController departmentNameController = TextEditingController();
  TextEditingController courseDetailController = TextEditingController();

  @override
  void initState() {
    courseDetailController.text = '${widget.courseID} - ${widget.courseName}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF731C65),
        title: const Text(
          'Student Evaluation Form ',
          style: TextStyle(color: Colors.white),
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
              'Student Evaluation Form',
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
            // TextField(
            //   controller: departmentNameController,
            //   decoration: const InputDecoration(
            //     labelText: '1) Name of the Department',
            //   ),
            // ),
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
                departmentNameController.text = value.toString();
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Text('😡  '),
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
                onPressed: () async {
                  if (departmentNameController.text.isEmpty) {
                    showMessage(context, 'Please enter department name.');
                    return;
                  }
                  // final supabase = Supabase.instance.client;

                  // var course = await supabase
                  //     .from('courses')
                  //     .select()
                  //     .eq(
                  //       'id',
                  //       widget.courseID,
                  //     )
                  //     .maybeSingle();

                  // if (course == null) {
                  //   showMessage(context,
                  //       'Provided course ID does not match any course in our database.');
                  //   return;
                  // }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Page2(
                        formData: {
                          'department': departmentNameController.text,
                        },
                        courseID: widget.courseID,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Next',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF731C65),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
