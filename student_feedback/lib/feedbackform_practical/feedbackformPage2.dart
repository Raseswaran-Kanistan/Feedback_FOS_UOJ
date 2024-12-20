import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage3.dart';
import '../router/router.dart';

class practicalPage2 extends StatefulWidget {
  final Map<String, dynamic>? formData;

  practicalPage2({this.formData});

  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<practicalPage2>
    with SingleTickerProviderStateMixin {
  // State variables to track dropdown values and comments
  String? objectives;
  String? contentOrganization;
  String? practicalManagement;
  String? reasoning;
  String? problemSolving;
  String? communication;
  String? creativity;
  String? otherSkills;

  final List<String> options = ['😡 ', '🙁 ', '😐 ', '🙂 ', '😃 '];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);
    _animationController.forward();

    // Initialize state variables with existing form data if present
    objectives = widget.formData?['objectives'];
    contentOrganization = widget.formData?['contentOrganization'];
    practicalManagement = widget.formData?['practicalManagement'];
    reasoning = widget.formData?['reasoning'];
    problemSolving = widget.formData?['problemSolving'];
    communication = widget.formData?['communication'];
    creativity = widget.formData?['creativity'];
    otherSkills = widget.formData?['otherSkills'];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndProceed() {
    // Check if all required fields are filled
    if (objectives == null ||
        contentOrganization == null ||
        practicalManagement == null ||
        reasoning == null ||
        problemSolving == null ||
        communication == null ||
        creativity == null) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please answer all questions before proceeding.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Prepare form data for the next page
      // GoRouter.of(context).go(Routers.feedbackformPage3.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => practicalPage3(
            formData: {
              ...?widget.formData,
              'objectives': objectives,
              'contentOrganization': contentOrganization,
              'practicalManagement': practicalManagement,
              'reasoning': reasoning,
              'problemSolving': problemSolving,
              'communication': communication,
              'creativity': creativity,
              'otherSkills': otherSkills
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF731C65), // Updated color
        title: const Text(
          'Student Evaluation Form-Practical',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            final canPop = GoRouter.of(context).canPop();
            if (canPop) {
              GoRouter.of(context).pop();
            } else {
              // Optionally navigate to a default route if there's nothing to pop
              GoRouter.of(context)
                  .go('/practicalPage1'); // Replace with your desired route
            }
          },
          icon: const Icon(
            CupertinoIcons.back,
            size: 35,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    const Text(
                      'Section B:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'To what extent would you agree that you have enough opportunity for involvement in the following aspects of the academic process?',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Course Content and Organization',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownQuestion(
                      'Objectives / ILO are clearly stated.',
                      objectives,
                      (String? newValue) {
                        setState(() {
                          objectives = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Course content is logically organized and presented.',
                      contentOrganization,
                      (String? newValue) {
                        setState(() {
                          contentOrganization = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Able to manage the practical within the stipulated time.',
                      practicalManagement,
                      (String? newValue) {
                        setState(() {
                          practicalManagement = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'The course contributed to my following skill development:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    _buildDropdownQuestion(
                      'Reasoning',
                      reasoning,
                      (String? newValue) {
                        setState(() {
                          reasoning = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Problem solving',
                      problemSolving,
                      (String? newValue) {
                        setState(() {
                          problemSolving = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Communication of ideas',
                      communication,
                      (String? newValue) {
                        setState(() {
                          communication = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Creativity',
                      creativity,
                      (String? newValue) {
                        setState(() {
                          creativity = newValue;
                        });
                      },
                    ),
                    _buildCommentBox(
                      'Any other skills (Specify)',
                      otherSkills,
                      (String newValue) {
                        setState(() {
                          otherSkills = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _validateAndProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF731C65), // Updated color
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
      ),
    );
  }

  Widget _buildDropdownQuestion(
      String question, String? currentValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF731C65)),
          ),
          // padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CustomDropdown<String>(
            value: currentValue,
            hint: const Text(
              'Select an option',
              style: TextStyle(color: Color(0xFF731C65)),
            ),
            onChanged: onChanged,
            items: options.map<CustomDropdownMenuItem<String>>((String value) {
              return CustomDropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(fontSize: 24),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCommentBox(
      String question, String? currentValue, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF731C65)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            onChanged: onChanged,
            maxLines: 3,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintText: 'Enter your comments',
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Custom dropdown button widget
class CustomDropdown<T> extends StatefulWidget {
  final T? value;
  final Widget? hint;
  final ValueChanged<T?>? onChanged;
  final List<CustomDropdownMenuItem<T>> items;

  const CustomDropdown(
      {this.value, this.hint, this.onChanged, required this.items});

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  late OverlayEntry _overlayEntry;
  late LayerLink _layerLink;
  final GlobalKey _dropdownKey = GlobalKey();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _layerLink = LayerLink();
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _dropdownKey.currentContext!.findRenderObject() as RenderBox;
    Size size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.items.map((CustomDropdownMenuItem<T> item) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _isOpen = false;
                        });
                        _overlayEntry.remove();
                        widget.onChanged!(item.value);
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: item.child,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _dropdownKey,
        onTap: () {
          if (_isOpen) {
            _overlayEntry.remove();
          } else {
            _overlayEntry = _createOverlayEntry();
            Overlay.of(context)!.insert(_overlayEntry);
          }
          setState(() {
            _isOpen = !_isOpen;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFF731C65)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              widget.value == null
                  ? widget.hint!
                  : widget.items
                      .firstWhere((item) => item.value == widget.value)
                      .child,
              Icon(
                _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Color(0xFF731C65),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropdownMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  CustomDropdownMenuItem({required this.value, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
    );
  }
}
