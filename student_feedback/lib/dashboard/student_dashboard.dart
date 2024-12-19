import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/components/course_card.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage1.dart';
import 'package:student_feedback/feedbackform_theory/feedbackformPage1.dart';
import 'package:student_feedback/feedbackform_theory_and_practical/page1.dart';
import 'package:student_feedback/router/router.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Course {
  final String id;
  final String name;
  final List<String> enrolledStudents;
  final String type;
  String lecturer;

  Course({
    required this.id,
    required this.name,
    required this.enrolledStudents,
    required this.type,
    this.lecturer = 'Not assigned',
  });
}

class StudentDashboard extends StatefulWidget {
  final String? message;

  const StudentDashboard({super.key, this.message});
  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  Map userData = {};
  String studentId = '';
  final supabase = Supabase.instance.client;

  List<Course> courses = [];

  void initialiseData() async {
    courses = [];
    userData = await getSession();
    studentId = userData['userId'].toString();

    List studentCourses = await supabase
        .from('student_course')
        .select('*, courses(*)')
        .eq('student', studentId);

    for (var course in studentCourses) {
      setState(() {
        courses.add(Course(
            id: course['courses']['id'].toString(),
            name: course['courses']['name'].toString(),
            enrolledStudents: [],
            type: course['course_type'].toString()));
      });
    }

    courses.forEach((course) async {
      await supabase
          .from('lecturer_course')
          .select('*, lecturer(*)')
          .eq('course', course.id)
          .eq('course_type', course.type)
          .maybeSingle()
          .then((value) {
        if (value != null) {
          setState(() {
            course.lecturer = value['lecturer']['name'].toString();
          });
        }
      });
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (widget.message != null) {
        showMessage(context, widget.message!);
      }
    });
  }

  @override
  void initState() {
    initialiseData();
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
        onRefresh: () async => initialiseData(),
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
                      elevation: 8,
                      shadowColor: Colors.grey.shade800,
                      child: Image.network(
                        'https://media.istockphoto.com/id/1300845620/vector/user-icon-flat-isolated-on-white-background-user-symbol-vector-illustration.jpg?s=612x612&w=0&k=20&c=yBeyba0hUkh14_jgv1OKqIH0CCSWU_4ckRkAoy2p73o=',
                        width: 50,
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child:
                              Text('You are signed in as ${userData['email']}'),
                        ),
                        PopupMenuItem(
                          value: 'logout',
                          child: const Text('Logout'),
                          onTap: () => logoutUser(context),
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Courses That You are Enrolled',
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold, height: 1),
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
                            title: course.name,
                            miniTitle: course.type == 'both'
                                ? 'Theory & Practical'
                                : course.type,
                            buttonLabel: 'Add Feedback',
                            studentCount: (course.enrolledStudents).length,
                            cardColor: _getCourseColor(course.type),
                            isStudent: true,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.44,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${course.lecturer}\n',
                                    ),
                                    TextSpan(
                                      text: '${course.id}\n',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onButtonPressed: () {
                              switch (course.type.toLowerCase()) {
                                case 'theory':
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Page1(
                                            courseID: course.id,
                                            courseName: course.name,
                                          )));
                                  break;
                                case 'practical':
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => practicalPage1(
                                            courseID: course.id,
                                            courseName: course.name,
                                            courseType: course.type,
                                          )));
                                  break;
                                default:
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => BothFeedbackPageOne(
                                            courseID: course.id,
                                            courseName: course.name,
                                            courseType: course.type,
                                          )));
                              }
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

  Color _getCourseColor(String courseType) {
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
}
