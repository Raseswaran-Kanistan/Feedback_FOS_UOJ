import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_feedback/components/back_button.dart';
import 'package:student_feedback/screens/feedback_view.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewCourse extends StatefulWidget {
  const ViewCourse({super.key, required this.details});

  final PostgrestList details;
  @override
  State<ViewCourse> createState() => _ViewCourseState();
}

class _ViewCourseState extends State<ViewCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(50),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(8),
                  CustomBackButton(
                    height: 43,
                  ),
                  Spacer(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Viewing ${widget.details[0]['course']['name']}',
                style: const TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold, height: 1),
              ),
            ),

            const SizedBox(height: 30),

            // body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'This course is currently being taught by: ${widget.details.length} lecturers',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            ...widget.details.map((lect_course) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackView(
                        courseID: lect_course['course']['id'],
                        courseType: lect_course['course_type'],
                        courseName: lect_course['course']['name'],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(lect_course['lecturer']['name']),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                lect_course['lecturer']['email'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                lect_course['course_type'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey.shade600,
                        ),
                        const Gap(8),
                      ],
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
