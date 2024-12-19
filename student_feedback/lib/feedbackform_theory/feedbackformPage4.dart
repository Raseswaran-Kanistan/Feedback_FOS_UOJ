import 'package:flutter/material.dart';
import 'feedbackformPage5.dart';

class Page4 extends StatefulWidget {
  final Map<String, dynamic>? formData; // Receive formData from previous page

  Page4({required this.formData, required this.courseID});

  final String courseID;

  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> with SingleTickerProviderStateMixin {
  // State variables to track dropdown values
  String? stimulateInterest;
  String? appropriatePace;
  String? clearExplanation;
  String? reasonableTime;
  String? confidentDelivery;

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
    stimulateInterest = widget.formData?['stimulateInterest'];
    appropriatePace = widget.formData?['appropriatePace'];
    clearExplanation = widget.formData?['clearExplanation'];
    reasonableTime = widget.formData?['reasonableTime'];
    confidentDelivery = widget.formData?['confidentDelivery'];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndProceed() {
    // Check if all required fields are filled
    if (stimulateInterest == null ||
        appropriatePace == null ||
        clearExplanation == null ||
        reasonableTime == null ||
        confidentDelivery == null) {
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
        'stimulateInterest': stimulateInterest,
        'appropriatePace': appropriatePace,
        'clearExplanation': clearExplanation,
        'reasonableTime': reasonableTime,
        'confidentDelivery': confidentDelivery,
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Page5(
            formData: updatedFormData,
            courseID: widget.courseID,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF731C65), // Updated color
        title: Text(
          'Student Evaluation Form ',
          style: TextStyle(
            color: Colors.white,
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
                      'Quality of delivery',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(height: 20),
                    _buildDropdownQuestion(
                      'The method of lecture delivery  always stimulates interest in learning.',
                      stimulateInterest,
                      (String? newValue) {
                        setState(() {
                          stimulateInterest = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'The lecturer maintained  appropriate pace for my understanding and note-taking.',
                      appropriatePace,
                      (String? newValue) {
                        setState(() {
                          appropriatePace = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Important concepts are clearly explained by the lecture.',
                      clearExplanation,
                      (String? newValue) {
                        setState(() {
                          clearExplanation = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Reasonable time is given for clarification regarding the lecture.',
                      reasonableTime,
                      (String? newValue) {
                        setState(() {
                          reasonableTime = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'The lecture was confident in delivering the content.',
                      confidentDelivery,
                      (String? newValue) {
                        setState(() {
                          confidentDelivery = newValue;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
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
    return child;
  }
}
