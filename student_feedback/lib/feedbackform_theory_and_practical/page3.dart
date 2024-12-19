import 'package:flutter/material.dart';
import 'page4.dart'; // Import the Page4 widget

class BothFeedbackPageThree extends StatefulWidget {
  final Map<String, dynamic>? formData;

  BothFeedbackPageThree({this.formData});

  @override
  _BothFeedbackPageThreeState createState() => _BothFeedbackPageThreeState();
}

class _BothFeedbackPageThreeState extends State<BothFeedbackPageThree>
    with SingleTickerProviderStateMixin {
  // State variables to track dropdown values
  String? conduciveEnvironment;
  String? conduciveEnvironmentForClass;
  String? adequateFacilities;
  String? adequateEquipment;
  String? wellOrganizedFieldTrips;

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
    conduciveEnvironment = widget.formData?['conduciveEnvironment'];
    conduciveEnvironmentForClass =
        widget.formData?['conduciveEnvironmentForClass'];
    adequateFacilities = widget.formData?['adequateFacilities'];
    adequateEquipment = widget.formData?['adequateEquipment'];
    wellOrganizedFieldTrips = widget.formData?['wellOrganizedFieldTrips'];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _validateAndProceed() {
    // Check if all required fields are filled
    if (conduciveEnvironment == null ||
        conduciveEnvironmentForClass == null ||
        adequateFacilities == null ||
        adequateEquipment == null ||
        wellOrganizedFieldTrips == null) {
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
        'conduciveEnvironment': conduciveEnvironment,
        'conduciveEnvironmentForClass': conduciveEnvironmentForClass,
        'adequateFacilities': adequateFacilities,
        'adequateEquipment': adequateEquipment,
        'wellOrganizedFieldTrips': wellOrganizedFieldTrips
      };
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BothFeedbackPageFour(
            formData: updatedFormData,
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
                      'Learning Environment',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    _buildDropdownQuestion(
                      'There is a conducive environment in and around the laboratory.',
                      conduciveEnvironment,
                      (String? newValue) {
                        setState(() {
                          conduciveEnvironment = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'There is a conducive environment in and around the classroom.',
                      conduciveEnvironmentForClass,
                      (String? newValue) {
                        setState(() {
                          conduciveEnvironmentForClass = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Adequate facilities are available for my learning.',
                      adequateFacilities,
                      (String? newValue) {
                        setState(() {
                          adequateFacilities = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Adequate equipment are available.',
                      adequateEquipment,
                      (String? newValue) {
                        setState(() {
                          adequateEquipment = newValue;
                        });
                      },
                    ),
                    _buildDropdownQuestion(
                      'Field trips (if any) are well organized and conducive for learning.',
                      wellOrganizedFieldTrips,
                      (String? newValue) {
                        setState(() {
                          wellOrganizedFieldTrips = newValue;
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
                    backgroundColor: Color(0xFF731C65), // Updated color
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
