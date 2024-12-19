import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:student_feedback/components/back_button.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

final List<String> options = [
  '1',
  '2',
  '3',
  '4',
  '5',
];

class FeedbackView extends StatefulWidget {
  const FeedbackView({
    super.key,
    required this.courseID,
    required this.courseType,
    required this.courseName,
  });

  final String courseID;
  final String courseType;
  final String courseName;

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  List<_ChartData> data = [];
  // late TooltipBehavior _tooltip;
  List feedbacks = [];
  double numberOfStudents = 0;
  Map<String, dynamic> summary = {};
  bool isProcessing = false;

  void _setProgressIndicator(bool value) {
    setState(() {
      isProcessing = value;
    });
  }

  @override
  void initState() {
    _setProgressIndicator(true);
    try {
      _fetchFeedbacks();
      // data = [
      //   _ChartData(options[0], 5),
      //   _ChartData(options[1], 2),
      //   _ChartData(options[2], 7),
      //   _ChartData(options[3], 6.4),
      //   _ChartData(options[4], 8)
      // ];
    } catch (e) {
      //
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        _setProgressIndicator(false);
        _processFeedbacks();
      });
    }
    // _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isProcessing
            ? const Center(
                child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  Gap(8),
                  Text('Processing Feedbacks...'),
                ],
              ))
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(16),
                      const CustomBackButton(),
                      const Gap(16),
                      Text(
                        '${widget.courseID} - ${widget.courseName} Feedbacks',
                        style: const TextStyle(
                            fontSize: 30,
                            height: 1.5,
                            fontWeight: FontWeight.bold),
                      ),
                      if (getSummarizedFeedbacks().isEmpty) ...[
                        const Gap(200),
                        Center(
                          child: Text(
                            'No feedback found',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                      ...getSummarizedFeedbacks(),
                      const Gap(16),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _fetchFeedbacks() async {
    var sessionData = await getSession();
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('feedback')
        .select()
        .eq('course_id', widget.courseID)
        .eq('course_type', widget.courseType);

    setState(() {
      feedbacks = response;
    });

    final students = await supabase
        .from('student_course')
        .select()
        .eq('course', widget.courseID)
        .eq('course_type', widget.courseType);

    setState(() {
      numberOfStudents = double.parse(students.length.toString());
      numberOfStudents = numberOfStudents > 10 ? numberOfStudents : 5;
    });

    // print('the number of students is $numberOfStudents');
  }

  void _processFeedbacks() {
    for (var feedback in feedbacks) {
      // get each key and value
      feedback.forEach((key, value) {
        setState(() {
          if (summary[key] == null) {
            summary[key] = [
              {value: 1}
            ];
          } else {
            summary[key].toList().forEach((e) => {
                  if (e[value] == null) {e[value] = 1} else {e[value]++}
                });
          }
        });
      });
    }
  }

  List<Widget> getSummarizedFeedbacks() {
    List<Widget> widgets = [];
    bool skipCurrentChart = false;
    // print('the summary is $summary');

    summary.forEach((key, value) {
      if (_skip(key)) return;
      List<_ChartData> chartData = [
        _ChartData(options[0], 0),
        _ChartData(options[1], 0),
        _ChartData(options[2], 0),
        _ChartData(options[3], 0),
        _ChartData(options[4], 0),
      ];
      value[0].forEach((vk, val) {
        if (double.parse(val.toString()) == 0) {
          skipCurrentChart = true;
        }
        switch (vk.toString().trim()) {
          case '😡':
            chartData[0].y = double.parse(val.toString());
            break;
          case '🙁':
            chartData[1].y = double.parse(val.toString());
            break;
          case '😐':
            chartData[2].y = double.parse(val.toString());
            break;
          case '🙂':
            chartData[3].y = double.parse(val.toString());
            break;
          case '😃':
            chartData[4].y = double.parse(val.toString());
            break;
        }

        // chartData.add(_ChartData('$vk - $val', double.parse(val.toString())));
      });
      if (skipCurrentChart) {
        skipCurrentChart = false;
        return;
      }
      widgets.add(showChart(title: _getTitle(key), chartData: chartData));
    });

    return widgets;
  }

  Widget showChart(
      {required String title, required List<_ChartData> chartData}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ]),
        child: SfCartesianChart(
            title: ChartTitle(text: title),
            primaryXAxis: const CategoryAxis(
              title: AxisTitle(
                text: '(1)Strongly Disagree - (5)Strongly Agree',
              ),
              labelStyle: TextStyle(fontSize: 14),
            ),
            primaryYAxis: NumericAxis(
                minimum: 0, maximum: numberOfStudents, interval: 10),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<_ChartData, String>>[
              ColumnSeries<_ChartData, String>(
                borderRadius: BorderRadius.circular(4),
                dataSource: chartData,
                xValueMapper: (_ChartData data, _) => data.x,
                yValueMapper: (_ChartData data, _) => data.y,
                name: 'Gold',
                color: const Color.fromRGBO(8, 142, 255, 1),
              )
            ]),
      ),
    );
  }

  String _getTitle(String key) {
    switch (key) {
      case 'objectives':
        return 'Objectives/ILO are clearly stated.';
      case 'content_organization':
        return 'Content are organized clearly.';
      default:
        return key;
    }
  }

  bool _skip(String key) {
    switch (key) {
      case 'id':
        return true;
      case 'created_at':
        return true;
      case 'course_id':
        return true;
      case 'course_type':
        return true;
      case 'department':
        return true;
      case 'like_most':
        return true;
      case 'dislike_most':
        return true;
      case 'recommendations':
        return true;
      case 'feedback_usefulness':
        return true;
      case 'student_id':
        return true;
      case 'environment_practical':
        return true;
      case 'like_most_practical':
        return true;
      case 'dislike_most_practical':
        return true;
      case 'recommendations_practical':
        return true;
      default:
        return false;
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  String x;
  double y;
}
