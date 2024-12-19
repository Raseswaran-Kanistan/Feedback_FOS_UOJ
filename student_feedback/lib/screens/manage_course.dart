import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_feedback/components/back_button.dart';
import 'package:student_feedback/dashboard/add_student.dart';
import 'package:student_feedback/dashboard/edit_course.dart';
import 'package:student_feedback/screens/coure_students.dart';
import 'package:student_feedback/screens/feedback_view.dart';
import 'package:student_feedback/screens/register_page.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageCoursePage extends StatefulWidget {
  ManageCoursePage({
    super.key,
    required this.course,
    required this.courses,
    required this.onUpdate,
  });

  Map<String, dynamic> course;
  List courses;
  Function() onUpdate;

  @override
  State<ManageCoursePage> createState() => _ManageCoursePageState();
}

class _ManageCoursePageState extends State<ManageCoursePage> {
  Map<String, dynamic> course = {};
  List students = [];
  final supabase = Supabase.instance.client;
  Map spinner = {
    'loading': false,
    'type': '',
  };

  void setSpinner(bool value) => setState(() => spinner['loading'] = value);
  void setSpinnerType(String value) => setState(() => spinner['type'] = value);
  bool getSpinner(String type) => spinner['loading'] && spinner['type'] == type;

  @override
  void initState() {
    course = widget.course;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomBackButton(),
              const Gap(24),
              // course title
              Text(
                course['name'].toString(),
                style: const TextStyle(
                  fontSize: 42,
                  height: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              // course type
              Text(
                course['type'].toString(),
                style: const TextStyle(
                  fontSize: 20,
                  height: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Gap(24),

              actionButton(
                'Add Students',
                icon: const Icon(Icons.person_add),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => AddStudentPage(
                      onAddStudent: (studentId, studentData) {
                        course['students']
                            .add({'id': studentId, 'data': studentData});
                        widget.onUpdate();
                      },
                      courseId: course['id'],
                      courseType: course['type'],
                    ),
                  );
                },
              ),
              const Gap(8),
              actionButton(
                'View Students',
                icon: const Icon(Icons.people),
                onTap: () {
                  setSpinner(true);
                  setSpinnerType(('View students').toLowerCase());
                  showStudentsDialog(course['id'], course['name']);
                },
              ),
              const Gap(8),
              actionButton(
                'Edit Course',
                icon: const Icon(Icons.edit_document),
                onTap: editCourse,
              ),
              const Gap(8),
              actionButton(
                'Delete Course',
                icon: const Icon(Icons.delete),
                onTap: deleteCourse,
              ),

              const Gap(8),
              actionButton(
                'View Feedbacks',
                width: double.infinity,
                icon: Icon(Icons.menu_book_outlined),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackView(
                          courseID: course['id'],
                          courseType: course['type'],
                          courseName: course['name'],
                        ),
                      ));
                },
                height: 80,
              ),

              // const Gap(8),
              // actionButton(
              //   'Back to Dashboard',
              //   width: double.infinity,
              //   height: 80,
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget actionButton(String title,
      {Icon? icon, double? width, double? height = 80, Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) icon,
              const Gap(24),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              if (getSpinner(title.toLowerCase()))
                const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  void showStudentsDialog(String courseId, String courseName) async {
    List<Map<String, dynamic>> allStudents = [];
    final students = await supabase
        .from('student_course')
        .select('*')
        .eq(
          'course',
          courseId,
        )
        .eq('course_type', widget.course['type'])
        .onError((error, stackTrace) {
      setSpinner(false);
      print(error);
      return [];
    });

    print(
        'the widget course type and id are ${widget.course['type']} and ${widget.course['id']}');
    print('the students are ${students}');

    for (var student in students) {
      final studentData = await supabase
          .from('users')
          .select()
          .eq('id', student['student'])
          .limit(1)
          .maybeSingle();

      if (studentData == null) return;

      allStudents.add({
        'name': studentData['name'],
        'id': studentData['id'],
      });
    }

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CourseStudents(
                  students: allStudents,
                  courseId: courseId,
                  courseName: courseName,
                )));

    setSpinner(false);
  }

  void editCourse() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EditCoursePage(
              course: widget.course,
              onEditCourse: (courseId, courseName, courseType) {
                setState(() {
                  // Update the course information
                  widget.course = {
                    'id': courseId,
                    'name': courseName,
                    'type': courseType.toLowerCase(),
                    'students': (widget.course['students'] ??
                        []), // Keep the students unchanged
                  };
                  course = widget.course;
                });

                widget.onUpdate();
              },
            )));
  }

  void deleteCourse() async {
    // ask for confirmation
    final result = await confirmAction(
      'Delete Course',
      'Are you sure you want to delete this course?',
      context,
    );

    if (result == null || !result) return;

    final supabase = Supabase.instance.client;

    if (widget.course['type'].toString().toLowerCase() == 'both') {
      await supabase.from('courses').delete().eq('id', widget.course['id']);
    } else {
      var course = await supabase
          .from('courses')
          .select()
          .eq('id', widget.course['id'])
          .maybeSingle();

      if (course == null) {
        showMessage(context, 'Something went wrong! please try again!');
        return;
      }

      String? newCourseType;
      if (course['type'].toString().toLowerCase() == 'both') {
        newCourseType =
            widget.course['type'] == 'theory' ? 'practical' : 'theory';
      }

      if (newCourseType == null) {
        await supabase.from('courses').delete().eq('id', widget.course['id']);
      } else {
        await supabase
            .from('courses')
            .update({'type': newCourseType}).eq('id', widget.course['id']);
        await supabase
            .from('lecturer_course')
            .delete()
            .eq('course', widget.course['id'])
            .eq('course_type', widget.course['type']);
        await supabase
            .from('student_course')
            .delete()
            .eq('course', widget.course['id'])
            .eq('course_type', widget.course['type']);
        await supabase
            .from('feedback')
            .delete()
            .eq('course_id', widget.course['id'])
            .eq('course_type', widget.course['type']);
      }
    }

    bool isDeleted = false;

    setState(() {
      for (var course in widget.courses) {
        if (course['id'] == widget.course['id']) {
          widget.courses.remove(course);
          isDeleted = true;
          break;
        }
      }
    });

    if (isDeleted) {
      showMessage(context, 'Course deleted successfully!');
      widget.onUpdate();
      Navigator.pop(context);
    }
  }
}
