import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_feedback/screens/user_management_screen.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:student_feedback/utils/text_styles.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final supabase = Supabase.instance.client;

  _getStudentData() async {
    final data = await supabase.from('users').select().eq('role', 'student');
    final List<Map<String, dynamic>> _students = [];

    for (var studentData in data) {
      _students.add({
        'SID': studentData['id'],
        'Sname': studentData['name'] ?? 'Unknown',
        'Semail': studentData['email'],
      });
    }
    return _students;
  }

  _getLecturerData() async {
    final data = await supabase.from('users').select().eq('role', 'lecturer');
    final List<Map<String, String>> _lecturers = [];
    for (var lecturerData in data) {
      _lecturers.add({
        'LID': lecturerData['id'],
        'Lname': lecturerData['name'] ?? 'Unknown',
        'Lemail': lecturerData['email'],
      });
    }

    return _lecturers;
  }

  _getCourseData() async {
    final data = await supabase.from('courses').select();
    final List<Map<String, String>> _courses = [];

    for (var courseData in data) {
      _courses.add({
        'CID': courseData['id'],
        'Cname': courseData['name'],
        'Ctype': courseData['type'],
      });
    }

    return _courses;
  }

  _initializeData() async {
    final studentData = await _getStudentData();
    final lecturersData = await _getLecturerData();
    final coursesData = await _getCourseData();
    setState(() {
      _students = studentData;
      _lecturers = lecturersData;
      _filteredStudents = studentData;
      _filteredLecturers = lecturersData;
      _filteredCourses = coursesData;
    });
  }

  String dropdownValue = 'Student';
  List<Map<String, dynamic>> _students = [];
  List<Map<String, String>> _lecturers = [];

  List<Map<String, dynamic>> _filteredStudents = [];
  List<Map<String, String>> _filteredLecturers = [];
  List<Map<String, String>> _filteredCourses = [];

  final _sidController = TextEditingController();
  final _semailController = TextEditingController();
  final _lidController = TextEditingController();
  final _lemailController = TextEditingController();

  final _formKeyStudent = GlobalKey<FormState>();
  final _formKeyLecturer = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () async => _initializeData(),
          child: Column(
            children: [
              const Gap(50),
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
                        const PopupMenuItem(
                          child: Text('You are signed in as Admin'),
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
                  'Manage Students and Lecturers',
                  style: TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold, height: 1),
                ),
              ),

              const SizedBox(height: 10),
              customCard(
                'Lecturers',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageUser(
                        onDelete: (value) {
                          setState(() {
                            _filteredLecturers.remove(value);
                          });
                          _initializeData();
                        },
                        onUpdate: (value) {
                          _initializeData();
                        },
                        userType: UserType.lecturer,
                        content: _filteredLecturers,
                        onUserAdded: (value) {
                          setState(() {
                            _filteredLecturers.add(value);
                          });
                        },
                      ),
                    ),
                  );
                },
                cardColor: Colors.orange.shade300,
              ),
              customCard(
                'Students',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageUser(
                        onDelete: (value) {
                          setState(() {
                            _filteredStudents.remove(value);
                          });
                          _initializeData();
                        },
                        onUpdate: (value) {
                          _initializeData();
                        },
                        userType: UserType.student,
                        content: _filteredStudents,
                        onUserAdded: (value) {
                          setState(() {
                            _filteredStudents.add(value);
                          });
                        },
                      ),
                    ),
                  );
                },
                cardColor: Colors.blue.shade300,
              ),
              customCard(
                'Courses',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManageUser(
                        onDelete: (value) {},
                        onUpdate: (value) {},
                        userType: UserType.course,
                        content: _filteredCourses,
                        onUserAdded: (value) {},
                      ),
                    ),
                  );
                },
                cardColor: Colors.green.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customCard(String title, Function() onTap,
      {Color cardColor = Colors.white}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            // edit button
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Manage $title',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      size: 20,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _addStudent() async {
    if (_formKeyStudent.currentState!.validate()) {
      await supabase.from('users').insert({
        'id': _sidController.text.trim(),
        'email': _semailController.text.trim(),
        'role': 'student',
      });
      _initializeData();
      setState(() {
        _sidController.clear();
        _semailController.clear();
      });
      showMessage(context, 'Student added successfully!');
      Navigator.of(context).pop();
    }
  }

  void _editStudent(int index) async {
    if (_formKeyStudent.currentState!.validate()) {
      setState(() {
        _filteredStudents[index] = {
          'SID': _sidController.text,
          'Sname': _filteredStudents[index]['Sname'],
          'Semail': _semailController.text,
        };
      });

      final supabase = Supabase.instance.client;
      await supabase.from('users').update({
        'email': _semailController.text.trim(),
      }).eq('id', _sidController.text.trim());

      Navigator.of(context).pop();
      showMessage(context, 'Student updated successfully!');
    }
  }

  void _deleteStudent(int index) async {
    await supabase.from('users').delete().eq('id', _students[index]['SID']);
    setState(() {
      _students.removeAt(index);
      _filteredStudents = _students;
    });
    showMessage(context, 'Student deleted successfully!');
  }

  void _addLecturer() async {
    if (_formKeyLecturer.currentState!.validate()) {
      await supabase.from('users').insert({
        'id': _lidController.text.trim(),
        'email': _lemailController.text.trim(),
        'role': 'lecturer',
      });
      _initializeData();
      setState(() {
        _lidController.clear();
        _lemailController.clear();
      });
      showMessage(context, 'Lecturer added successfully!');
      Navigator.of(context).pop();
    }
  }

  void _editLecturer(int index) {
    if (_formKeyLecturer.currentState!.validate()) {
      setState(() {
        _filteredLecturers[index] = {
          'LID': _lidController.text,
          'Lemail': _lemailController.text,
        };
      });
      Navigator.of(context).pop();
    }
  }

  void _deleteLecturer(int index) async {
    await supabase.from('users').delete().eq('id', _lecturers[index]['LID']!);
    setState(() {
      _lecturers.removeAt(index);
      _filteredLecturers = _lecturers;
    });
    showMessage(context, 'Lecturer deleted successfully!');
  }

  void _searchStudent(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStudents = _students;
      } else {
        _filteredStudents = _students.where((student) {
          return student['SID']!.contains(query) ||
              student['Sname']!.toLowerCase().contains(query.toLowerCase()) ||
              student['Semail']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _searchLecturer(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLecturers = _lecturers;
      } else {
        _filteredLecturers = _lecturers.where((lecturer) {
          return lecturer['LID']!.contains(query) ||
              lecturer['Lname']!.toLowerCase().contains(query.toLowerCase()) ||
              lecturer['Lemail']!.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _showAddStudentDialog() {
    _sidController.clear();
    _semailController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Student"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKeyStudent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _sidController,
                    decoration: const InputDecoration(labelText: 'Student ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Student ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _semailController,
                    decoration:
                        const InputDecoration(labelText: 'Student Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Student Email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              onPressed: _addStudent,
              style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF731C65)),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditStudentDialog(int index) {
    _sidController.text = _filteredStudents[index]['SID']!;
    _semailController.text = _filteredStudents[index]['Semail']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Student"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKeyStudent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    enabled: false,
                    controller: _sidController,
                    decoration: const InputDecoration(labelText: 'Student ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Student ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _semailController,
                    decoration:
                        const InputDecoration(labelText: 'Student Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Student Email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () => _editStudent(index),
              style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF731C65)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteStudentDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Student"),
          content: const Text("Are you sure you want to delete this student?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Delete"),
              onPressed: () {
                _deleteStudent(index);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF731C65)),
            ),
          ],
        );
      },
    );
  }

  void _showAddLecturerDialog() {
    _lidController.clear();
    _lemailController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Lecturer"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKeyLecturer,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _lidController,
                    decoration: const InputDecoration(labelText: 'Lecturer ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Lecturer ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lemailController,
                    decoration:
                        const InputDecoration(labelText: 'Lecturer Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Lecturer Email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Add"),
              onPressed: _addLecturer,
              style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF731C65)),
            ),
          ],
        );
      },
    );
  }

  void _showEditLecturerDialog(int index) {
    _lidController.text = _lecturers[index]['LID']!;
    _lemailController.text = _lecturers[index]['Lemail']!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Lecturer"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKeyLecturer,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    enabled: false,
                    controller: _lidController,
                    decoration: const InputDecoration(labelText: 'Lecturer ID'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Lecturer ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lemailController,
                    decoration:
                        const InputDecoration(labelText: 'Lecturer Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Lecturer Email';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () => _editLecturer(index),
              style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF731C65)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteLecturerDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Lecturer"),
          content: const Text("Are you sure you want to delete this lecturer?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteLecturer(index);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF731C65)),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
