import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_feedback/components/back_button.dart';
import 'package:student_feedback/screens/admin_course_view.dart';
import 'package:student_feedback/screens/register_page.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum UserType {
  student,
  lecturer,
  course,
}

class ManageUser extends StatefulWidget {
  const ManageUser({
    super.key,
    required this.userType,
    required this.content,
    required this.onUserAdded,
    required this.onUpdate,
    required this.onDelete,
  });

  final UserType userType;
  final List content;
  final Function(Map<String, String> value) onUserAdded;
  final Function(Map<String, String> value) onUpdate;
  final Function(Map<String, String> value) onDelete;

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  List _filteredContent = [];
  List content = [];
  final supabase = Supabase.instance.client;
  bool spinner = false;
  String currentID = '';
  TextEditingController _userIDController = TextEditingController();
  TextEditingController _userEmailController = TextEditingController();

  @override
  void initState() {
    content = widget.content;
    _filteredContent = content;
    super.initState();
  }

  void setSpinner(value) => setState(() => spinner = value);
  void setCurrentId(id) => setState(() => currentID = id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Gap(50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(8),
                  const CustomBackButton(
                    height: 43,
                  ),
                  const Spacer(),

                  // Add user Button
                  if (widget.userType != UserType.course)
                    GestureDetector(
                      onTap: () {
                        if (widget.userType == UserType.student) {
                          _showAddUserAlert();
                        } else if (widget.userType == UserType.lecturer) {
                          _showAddUserAlert();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade300,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Add ${widget.userType.toString().split('.')[1]}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Icon(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Manage ${widget.userType.toString().split('.')[1]}s',
                style: const TextStyle(
                    fontSize: 40, fontWeight: FontWeight.bold, height: 1),
              ),
            ),

            const SizedBox(height: 10),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  focusColor: Colors.grey.shade200,
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                onChanged: (query) {
                  setState(() {
                    if (query.isEmpty) {
                      _filteredContent = content;
                    } else {
                      List temp = [];
                      content.forEach((element) {
                        if (element
                            .toString()
                            .toLowerCase()
                            .contains(query.toLowerCase())) {
                          temp.add(element);
                        }
                      });
                      _filteredContent = temp;
                    }
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            ..._filteredContent.map(
              (item) => InkWell(
                onTap: () async {
                  switch (widget.userType) {
                    case UserType.lecturer:
                      // Navigator.pushNamed(context, '/lecturer_dashboard',
                      //     arguments: item);
                      break;
                    case UserType.student:
                      // Navigator.pushNamed(context, '/student_dashboard',
                      //     arguments: item);
                      break;
                    case UserType.course:
                      setSpinner(true);
                      setCurrentId(item['CID']);
                      var lectuer_course = await supabase
                          .from('lecturer_course')
                          .select('*, lecturer(*), course(*)')
                          .eq('course', item['CID']);
                      setSpinner(false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewCourse(
                            details: lectuer_course,
                          ),
                        ),
                      );

                      break;
                  }
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
                    child: showContent(item),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showContent(content) {
    // return Text(content);
    switch (widget.userType) {
      case UserType.lecturer:
        return userCard(content);
      case UserType.student:
        return userCard(content);
      case UserType.course:
        return courseCard(content);
    }
  }

  Widget userCard(details) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(details['SID'] ?? details['LID']),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                details['Sname'] ?? details['Lname'],
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
                details['Semail'] ?? details['Lemail'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            _showEditUserAlert(details);
          },
          child: Icon(
            Icons.edit,
            color: Colors.grey.shade600,
          ),
        ),
        const Gap(24),
        InkWell(
          onTap: () {
            _deleteUser(details);
          },
          child: const Icon(
            Icons.delete,
            color: Colors.redAccent,
          ),
        ),
        const Gap(8),
      ],
    );
  }

  Widget courseCard(details) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(details['CID']),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text(
                details['Cname'],
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
                details['Ctype'],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (currentID == details['CID'] && spinner)
          const CircularProgressIndicator(
            strokeWidth: 3,
          ),
        if (currentID != details['CID'] ||
            (currentID == details['CID'] && !spinner))
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey.shade600,
          ),
        const Gap(8),
      ],
    );
  }

  void _showAddUserAlert() {
    // show alert dialog
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _userIDController,
                    decoration: InputDecoration(
                      labelText:
                          '${widget.userType.toString().split('.').last} ID',
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF731C65)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _userEmailController,
                    decoration: InputDecoration(
                      labelText:
                          '${widget.userType.toString().split('.').last} Email',
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF731C65)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    width: 1000,
                    message:
                        'Add ${widget.userType.toString().split('.').last}',
                    function: addUser,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditUserAlert(details) {
    _userIDController.text = details['SID'] ?? details['LID'];
    _userEmailController.text = details['Semail'] ?? details['Lemail'];
    // show alert dialog
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _userIDController,
                    decoration: InputDecoration(
                      labelText:
                          '${widget.userType.toString().split('.').last} ID',
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF731C65)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _userEmailController,
                    decoration: InputDecoration(
                      labelText:
                          '${widget.userType.toString().split('.').last} Email',
                      border: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF731C65)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    width: 1000,
                    message:
                        'Update ${widget.userType.toString().split('.').last}',
                    function: editUser,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void editUser() async {
    bool err = false;

    var user = await supabase
        .from('users')
        .select('*')
        .eq('email', _userEmailController.text.trim())
        .single()
        .onError((error, stackTrace) {
      return {};
    });

    if (user.isNotEmpty) {
      err = true;
      Navigator.pop(context);
      showMessage(context, 'Email already taken!');
      return;
    }

    await supabase
        .from('users')
        .update({
          'email': _userEmailController.text.trim(),
          'id': _userIDController.text.trim(),
          'role': widget.userType.toString().split('.').last
        })
        .eq('id', _userIDController.text.trim())
        .onError((error, stackTrace) {
          err = true;
        });

    if (err) {
      Navigator.pop(context);
      showMessage(context, 'Something went wrong please try again!');
      return;
    }

    Map<String, String> value = {};

    if (widget.userType == UserType.student) {
      value = {
        'SID': _userIDController.text.trim(),
        'Sname': 'Unknown',
        'Semail': _userEmailController.text.trim(),
      };
    } else {
      value = {
        'LID': _userIDController.text.trim(),
        'Lname': 'Unknown',
        'Lemail': _userEmailController.text.trim(),
      };
    }

    var tempContent = [];
    for (var content in _filteredContent) {
      if ((content['SID'] ?? content['LID']) == _userIDController.text.trim()) {
        tempContent.add(value);
      } else {
        tempContent.add(content);
      }
    }

    setState(() {
      _filteredContent = tempContent;
    });

    for (var content in widget.content) {
      if ((content['SID'] ?? content['LID']) == _userIDController.text.trim()) {
        tempContent.add(value);
      } else {
        tempContent.add(content);
      }
    }

    setState(() {
      content = tempContent;
    });

    widget.onUpdate(value);
    Navigator.pop(context);
    showMessage(context, 'User updated successfully!');
  }

  void addUser() async {
    bool err = false;

    var user = await supabase
        .from('users')
        .select('*')
        .eq('email', _userEmailController.text.trim())
        .single()
        .onError((error, stackTrace) {
      return {};
    });

    if (user.isNotEmpty) {
      err = true;
      Navigator.pop(context);
      showMessage(context, 'Email already taken!');
      return;
    }

    if (err == true) return;

    // setState(() => spinner = true);
    await supabase.from('users').insert({
      'email': _userEmailController.text.trim(),
      'id': _userIDController.text.trim(),
      'role': widget.userType.toString().split('.').last
    }).onError((error, stackTrace) {
      if (error.toString().contains('23505')) {
        Navigator.pop(context);
        showMessage(context, 'User already exists!');
      }
      err = true;
    });

    var response = await supabase
        .from('users')
        .select()
        .eq('id', _userIDController.text.trim())
        .single();

    Map<String, String> value = {};

    if (widget.userType == UserType.student) {
      value = {
        'SID': _userIDController.text.trim(),
        'Sname': 'Unknown',
        'Semail': _userEmailController.text.trim(),
      };
      // setState(() {
      //   _filteredContent.add(value);
      // });
    }

    if (widget.userType == UserType.lecturer) {
      value = {
        'LID': _userIDController.text.trim(),
        'Lname': 'Unknown',
        'Lemail': _userEmailController.text.trim(),
      };
      // setState(() {
      //   _filteredContent.add(value);
      // });
    }

    if (err) return;

    widget.onUserAdded(value);
    Navigator.pop(context);
    showMessage(context, 'User added successfully!');
    print('the response is $response');
    // setState(() => spinner = false);
  }

  _deleteUser(details) async {
    bool? response = await confirmAction(
        'Delete ${widget.userType.toString().split('.').last}!',
        'Do you really want to remove this ${widget.userType.toString().split('.').last}?',
        context);

    if (response == null || !response) return;

    await supabase
        .from('users')
        .delete()
        .eq('id', (details['SID'] ?? details['LID']));

    setState(() {
      _filteredContent.remove(details);
    });
    widget.onDelete(details);
  }
}
