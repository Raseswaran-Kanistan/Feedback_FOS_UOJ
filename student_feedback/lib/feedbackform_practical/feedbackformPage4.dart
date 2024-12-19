import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../router/router.dart';
import 'feedbackformPage5.dart';

class practicalPage4 extends StatefulWidget {
  final Map<String, dynamic>? formData; // Receive formData from previous page

  practicalPage4({required this.formData});

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<practicalPage4>
    with SingleTickerProviderStateMixin {
  // State variables to track dropdown values
  String? studentCentered;
  String? appropriateMethodologies;
  String? relevantResources;
  String? relevantReadings;
  String? availableReadings;
  String? adequateReadings;
  String? suggestedEResources;
  String? accessibleEResources;

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
    studentCentered = widget.formData?['studentCentered'];
    appropriateMethodologies = widget.formData?['appropriateMethodologies'];
    relevantResources = widget.formData?['relevantResources'];
    relevantReadings = widget.formData?['relevantReadings'];
    availableReadings = widget.formData?['availableReadings'];
    adequateReadings = widget.formData?['adequateReadings'];
    suggestedEResources = widget.formData?['suggestedEResources'];
    accessibleEResources = widget.formData?['accessibleEResources'];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndProceed() {
    // Check if all required fields are filled
    if (studentCentered == null ||
        appropriateMethodologies == null ||
        relevantResources == null ||
        relevantReadings == null ||
        availableReadings == null ||
        adequateReadings == null ||
        suggestedEResources == null ||
        accessibleEResources == null) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please answer all questions before proceeding.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Prepare form data for the next page
      Map<String, dynamic> updatedFormData = {
        ...?widget.formData,
        'studentCentered': studentCentered,
        'appropriateMethodologies': appropriateMethodologies,
        'relevantResources': relevantResources,
        'relevantReadings': relevantReadings,
        'availableReadings': availableReadings,
        'adequateReadings': adequateReadings,
        'suggestedEResources': suggestedEResources,
        'accessibleEResources': accessibleEResources,
      };

      // GoRouter.of(context).go(Routers.feedbackformPage5.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => practicalPage5(
            formData: updatedFormData,
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
        backgroundColor: Color(0xFF731C65), // Updated color
        title: Text(
          'Student Evaluation Form - Practical',
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
                  .go('/practicalPage3'); // Replace with your desired route
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
                    Text(
                      'Methods',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    _buildDropdownQuestion(
                      'Practicals are student-centered.',
                      studentCentered,
                      (String? newValue) {
                        setState(() {
                          studentCentered = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Appropriate methodologies are used.',
                      appropriateMethodologies,
                      (String? newValue) {
                        setState(() {
                          appropriateMethodologies = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Learning resources provided are relevant to the course content.',
                      relevantResources,
                      (String? newValue) {
                        setState(() {
                          relevantResources = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Recommended readings are relevant and updated.',
                      relevantReadings,
                      (String? newValue) {
                        setState(() {
                          relevantReadings = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Recommended readings are available and accessible.',
                      availableReadings,
                      (String? newValue) {
                        setState(() {
                          availableReadings = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Recommended resources are available adequately at the library.',
                      adequateReadings,
                      (String? newValue) {
                        setState(() {
                          adequateReadings = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'E-resources are suggested for my learning.',
                      suggestedEResources,
                      (String? newValue) {
                        setState(() {
                          suggestedEResources = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Recommended E-sources are accessible for my learning.',
                      accessibleEResources,
                      (String? newValue) {
                        setState(() {
                          accessibleEResources = newValue;
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
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF731C65), // Button color
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
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
