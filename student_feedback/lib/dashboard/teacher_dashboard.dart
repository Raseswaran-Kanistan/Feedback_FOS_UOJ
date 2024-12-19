import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_feedback/components/course_card.dart';
import 'package:student_feedback/screens/coure_students.dart';
import 'package:student_feedback/screens/feedback_view.dart';
import 'package:student_feedback/screens/manage_course.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_course.dart';
import 'add_student.dart';
import 'edit_course.dart';

class TeacherDashboard extends StatefulWidget {
  @override
  _TeacherDashboardState createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  bool spinner = false;
  List<Map<String, dynamic>> courses = [];
  final supabase = Supabase.instance.client;
  Map currentUser = {};

  void addCourse(String courseId, String courseName, String courseType) {
    setState(() {
      courses.add({
        'id': courseId,
        'name': courseName,
        'type': courseType,
        'students': [],
      });
    });
    showMessage(context, 'Course added successfully!');
  }

  void addStudent(String courseId, String studentId) async {
    try {
      setState(() {
        final course = courses.firstWhere((course) => course['id'] == courseId);
        course['students'].add({
          'id': studentId,
        });
      });
    } catch (e) {
      showMessage(context, 'Something went wrong! please try again!');
    }
  }

  void deleteCourse(int index) async {
    final supabase = Supabase.instance.client;
    await supabase.from('courses').delete().eq('id', courses[index]['id']);

    setState(() {
      courses.removeAt(index);
    });
  }

  void editCourse(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCoursePage(
          course: courses[index],
          onEditCourse: (courseId, courseName, courseType) {
            setState(() {
              // Update the course information
              courses[index] = {
                'id': courseId,
                'name': courseName,
                'type': courseType,
                'students': (courses[index]['students'] ??
                    []), // Keep the students unchanged
              };
            });
          },
        ),
      ),
    );
  }

  Color getCourseColor(String courseType) {
    switch (courseType) {
      case 'theory':
        return Colors.blue[100]!;
      case 'practical':
        return Colors.green[100]!;
      case 'both':
        return Colors.orange[100]!;
      default:
        return Colors.white;
    }
  }

  void _initData() async {
    courses = [];
    final supabase = Supabase.instance.client;
    currentUser = await getSession();
    final response = await supabase
        .from('lecturer_course')
        .select('*, courses(*)')
        .eq('lecturer', currentUser['userId'].toString());

    response.forEach((element) async {
      var course = element['courses'];

      course['type'] = element['course_type'];

      List courseStudents = await supabase
          .from('student_course')
          .select()
          .eq('course', course['id'])
          .eq('course_type', course['type'])
          .onError((error, stackTrace) {
        // print(error);
        return [];
      });

      setState(() {
        courses.add({...course, 'students': courseStudents});
      });
    });
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Teacher Dashboard',
      theme: ThemeData(
        primaryColor: const Color(0xFF731C65),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF731C65),
          secondary: const Color(0xFF731C65),
        ),
      ),
      home: RefreshIndicator(
        onRefresh: () async => _initData(),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(60),
              // Fixed Top Content: User Image and Add Course Button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // User Image
                    PopupMenuButton(
                      color: Colors.white,
                      elevation: 8,
                      shadowColor: Colors.grey.shade800,
                      child: Image.network(
                        'https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=',
                        width: 50,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text(
                              'You are signed in as ${currentUser['email']}'),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: const Text('Logout'),
                          onTap: () => logoutUser(context),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Add Course Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddCoursePage(
                              onAddCourse: addCourse,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade300,
                        ),
                        child: const Row(
                          children: [
                            Text(
                              'Add Course',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.add,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Courses That You Teach',
                  style: TextStyle(
                      fontSize: 50, fontWeight: FontWeight.bold, height: 1),
                ),
              ),

              const SizedBox(height: 10),

              // Scrollable List of Courses
              Expanded(
                child: courses.isEmpty
                    ? const Center(
                        child: Text(
                          'No Courses Found!',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: courses.length,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return CourseCard(
                            title: course['name'],
                            miniTitle: course['type'],
                            buttonLabel: 'Manage Course',
                            studentCount: (course['students'] ?? []).length,
                            cardColor: _getCourseColor(course['type']),
                            onButtonPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManageCoursePage(
                                    course: course,
                                    courses: courses,
                                    onUpdate: () {
                                      _initData();
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getCourseColor(String courseType) {
    switch (courseType.toLowerCase()) {
      case 'theory':
        return Colors.blue[100]!;
      case 'practical':
        return Colors.green[100]!;
      case 'both':
        return Colors.orange[100]!;
      default:
        return Colors.white;
    }
  }
}
