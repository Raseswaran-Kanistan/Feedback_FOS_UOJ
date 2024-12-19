import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_feedback/components/back_button.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CourseStudents extends StatefulWidget {
  const CourseStudents(
      {super.key,
      required this.students,
      required this.courseId,
      required this.courseName});

  final List<Map<String, dynamic>> students;
  final String courseId;
  final String courseName;

  @override
  State<CourseStudents> createState() => _CourseStudentsState();
}

class _CourseStudentsState extends State<CourseStudents> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomBackButton(),
                const Gap(24),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    'Students Enrolled in ${widget.courseName}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.students.isEmpty) ...[
                  const Gap(270),
                  Center(
                    child: Text(
                      'No students found',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
                if (widget.students.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              widget.students[index]['name'] ?? 'Undefined!'),
                          subtitle: Text('ID: ${widget.students[index]['id']}'),
                          trailing: IconButton(
                            onPressed: () {
                              deleteStudent(widget.courseId,
                                  widget.students[index]['id'], context);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  deleteStudent(String courseId, String studentId, BuildContext context) async {
    bool? response = await confirmAction('Delete Student',
        'Are you sure you want to delete this student', context);

    if (response == null || !response) return;

    try {
      await supabase
          .from('student_course')
          .delete()
          .eq('course', courseId)
          .eq('student', studentId);
      setState(() {
        widget.students.removeWhere((student) => student['id'] == studentId);
      });
      showMessage(context, 'Student deleted successfully!');
    } catch (e) {
      showMessage(context, 'Something went wrong! please try again!');
    }
  }
}
