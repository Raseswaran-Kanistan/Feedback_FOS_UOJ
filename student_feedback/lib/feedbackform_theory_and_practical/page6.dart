import 'package:flutter/material.dart';
import 'package:student_feedback/dashboard/student_dashboard.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BothFeedbackPageSix extends StatefulWidget {
  final Map<String, dynamic>? formData; // Receive formData from previous pages

  BothFeedbackPageSix({required this.formData});

  @override
  _BothFeedbackPageSixState createState() => _BothFeedbackPageSixState();
}

class _BothFeedbackPageSixState extends State<BothFeedbackPageSix>
    with SingleTickerProviderStateMixin {
  // State variables to track dropdown values
  String? assessmentSatisfaction;
  String? timelyFeedback;
  String? feedbackUsefulness;

  // Controllers for text fields
  final TextEditingController likeMostController = TextEditingController();
  final TextEditingController dislikeMostController = TextEditingController();
  final TextEditingController recommendationsController =
      TextEditingController();
  final TextEditingController likeMostControllerForCourse =
      TextEditingController();
  final TextEditingController dislikeMostControllerForCourse =
      TextEditingController();
  final TextEditingController recommendationsControllerForCourse =
      TextEditingController();

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

    // Initialize state variables and controllers with existing form data if present
    assessmentSatisfaction = widget.formData?['assessmentSatisfaction'];
    timelyFeedback = widget.formData?['timelyFeedback'];
    feedbackUsefulness = widget.formData?['feedbackUsefulness'];

    likeMostController.text = widget.formData?['likeMost'] ?? '';
    dislikeMostController.text = widget.formData?['dislikeMost'] ?? '';
    recommendationsController.text = widget.formData?['recommendations'] ?? '';
    likeMostControllerForCourse.text =
        widget.formData?['likeMostForCourse '] ?? '';
    dislikeMostControllerForCourse.text =
        widget.formData?['dislikeMostForCourse '] ?? '';
    recommendationsControllerForCourse.text =
        widget.formData?['recommendationsForCourse '] ?? '';
  }

  @override
  void dispose() {
    _animationController.dispose();
    likeMostController.dispose();
    dislikeMostController.dispose();
    recommendationsController.dispose();
    likeMostControllerForCourse.dispose();
    dislikeMostControllerForCourse.dispose();
    recommendationsControllerForCourse.dispose();
    super.dispose();
  }

  void _validateAndProceed() {
    // Check if all required fields are filled

    if (assessmentSatisfaction == null ||
        timelyFeedback == null ||
        feedbackUsefulness == null) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please answer all questions before proceeding.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Prepare form data for submission or further processing
      Map<String, dynamic> finalFormData = {
        ...?widget.formData,
        'assessmentSatisfaction': assessmentSatisfaction,
        'timelyFeedback': timelyFeedback,
        'feedbackUsefulness': feedbackUsefulness,
        'likeMost': likeMostController.text,
        'dislikeMost': dislikeMostController.text,
        'recommendations': recommendationsController.text,
        'likeMostForCourse': likeMostControllerForCourse.text,
        'dislikeMostForCourse': dislikeMostControllerForCourse.text,
        'recommendationsForCourse': recommendationsControllerForCourse.text,
      };
      {
        // Handle the form submission
        _submitForm(finalFormData);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF731C65), // Updated color
        title: Text(
          'Integrated Student Evaluation Form: Theory and Practical',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
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
                    Text(
                      'Assessment',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    _buildDropdownQuestion(
                      'I am satisfied with the assessment as it is reasonable and fair.',
                      assessmentSatisfaction,
                      (String? newValue) {
                        setState(() {
                          assessmentSatisfaction = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'I am always given my corrected assignments on time.',
                      timelyFeedback,
                      (String? newValue) {
                        setState(() {
                          timelyFeedback = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Feedback/comments on my assignment are useful and helpful for my improvement.',
                      feedbackUsefulness,
                      (String? newValue) {
                        setState(() {
                          feedbackUsefulness = newValue;
                        });
                      },
                    ),
                    _buildTextFieldQuestion(
                      'What do you like most about the course practical?',
                      likeMostController,
                    ),
                    _buildTextFieldQuestion(
                      'What are the most disliked factors about the course practical?',
                      dislikeMostController,
                    ),
                    _buildTextFieldQuestion(
                      'Give recommendations or suggestions for the improvement of this course practical.',
                      recommendationsController,
                    ),
                    _buildTextFieldQuestion(
                      'What do you like most about the course ?',
                      likeMostControllerForCourse,
                    ),
                    _buildTextFieldQuestion(
                      'What are the most disliked factors about the course ?',
                      dislikeMostControllerForCourse,
                    ),
                    _buildTextFieldQuestion(
                      'Give recommendations or suggestions for the improvement of this course .',
                      recommendationsControllerForCourse,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Thank you for your valuable time and contribution for Quality Enhancement.',
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: _validateAndProceed,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF731C65), // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                  ],
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
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFF731C65)),
          ),
          // padding: EdgeInsets.symmetric(horizontal: 12),
          child: CustomDropdown<String>(
            value: currentValue,
            hint: Text(
              'Select an option',
              style: TextStyle(color: Color(0xFF731C65)),
            ),
            onChanged: onChanged,
            items: options.map<CustomDropdownMenuItem<String>>((String value) {
              return CustomDropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 24),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextFieldQuestion(
      String question, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          question,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFF731C65)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderSide: BorderSide.none),
              hintText: 'Enter your response here',
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  void _submitForm(Map<String, dynamic> finalFormData) async {
    // Handle the form submission, such as saving the data or sending it to a server
    // For now, we'll just print the data
    // print('Form submitted: $finalFormData');

    final supabase = Supabase.instance.client;
    final sessionData = await getSession();

    // print('the final form data course id is ${finalFormData['courseID']}');

    Map data = {
      'department': finalFormData['department'],
      'course_id': finalFormData['courseID'],
      'student_id': sessionData['userId'].toString(),
      'course_type': finalFormData['courseType'],
      'objectives': finalFormData['objectives'],
      'content_organization': finalFormData['contentOrganization'],
      'practical_management': finalFormData['practicalManagement'],
      'workload_management': finalFormData['workloadManagement'],
      'reasoning': finalFormData['reasoning'],
      'problem_solving': finalFormData['problemSolving'],
      'communication': finalFormData['communication'],
      'creativity': finalFormData['creativity'],
      'other_skills': finalFormData['otherSkills'],
      'environment_practical': finalFormData['conduciveEnvironment'],
      'environment': finalFormData['conduciveEnvironmentForClass'],
      'facilities': finalFormData['adequateFacilities'],
      'adequate_equipment': finalFormData['adequateEquipment'],
      'organized_field_trips': finalFormData['wellOrganizedFieldTrips'],
      'student_centered': finalFormData['studentCentered'],
      'methodologies': finalFormData['appropriateMethodologies'],
      'relevent_resources': finalFormData['relevantResources'],
      'relevent_readings': finalFormData['relevantReadings'],
      'available_readings': finalFormData['availableReadings'],
      'adequate_readings': finalFormData['adequateReadings'],
      'suggested_resources': finalFormData['suggestedEResources'],
      'accessible_resources': finalFormData['accessibleEResources'],
      'stimulate_interest': finalFormData['stimulateInterest'],
      'appropriate_pace': finalFormData['appropriatePace'],
      'clear_explanation': finalFormData['clearExplanation'],
      'reasonable_time': finalFormData['reasonableTime'],
      'confident_delivery': finalFormData['confidentDelivery'],
      'assesment_satisfaction': finalFormData['assessmentSatisfaction'],
      'timely_feedback': finalFormData['timelyFeedback'],
      'feedback_usefulness': finalFormData['feedbackUsefulness'],
      'like_most_practical': finalFormData['likeMost'],
      'dislike_most_practical': finalFormData['dislikeMost'],
      'recommendations_practical': finalFormData['recommendations'],
      'like_most': finalFormData['likeMostForCourse'],
      'dislike_most': finalFormData['dislikeMostForCourse'],
      'recommendations': finalFormData['recommendationsForCourse'],
    };

    // print('data is $data');

    var existingFeedback = await supabase
        .from('feedback')
        .select()
        .eq('student_id', sessionData['userId'].toString())
        .eq('course_id', finalFormData['courseID'])
        .eq('course_type', finalFormData['courseType'])
        .maybeSingle();

    if (existingFeedback != null) {
      await supabase
          .from('feedback')
          .update(data)
          .eq('id', existingFeedback['id']);
    } else {
      await supabase.from('feedback').insert(data);
    }

    // Navigate to a different screen or show a confirmation message
    // For example:
    // Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDashboard(
          message: 'Feedback submitted!',
        ),
      ),
    );
  }
}

// Custom dropdown button widget
class CustomDropdown<T> extends StatefulWidget {
  final T? value;
  final Widget? hint;
  final ValueChanged<T?>? onChanged;
  final List<CustomDropdownMenuItem<T>> items;

  CustomDropdown({this.value, this.hint, this.onChanged, required this.items});

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
                  children: widget.items.map((item) {
                    return GestureDetector(
                      onTap: () {
                        widget.onChanged?.call(item.value);
                        _toggleDropdown();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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

  void _toggleDropdown() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context)?.insert(_overlayEntry);
      } else {
        _overlayEntry.remove();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        key: _dropdownKey,
        onTap: _toggleDropdown,
        child: Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xFF731C65)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              widget.value == null
                  ? widget.hint ?? SizedBox()
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
    return Container(child: child);
  }
}

void main() {
  runApp(MaterialApp(
    home: BothFeedbackPageSix(
        formData: {}), // Pass empty data or appropriate data if available
  ));
}