import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    this.cardColor = Colors.white,
    required this.title,
    this.miniTitle,
    required this.studentCount,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.isStudent = false,
    this.child,
  });

  final Color? cardColor;
  final String title;
  final String? miniTitle;
  final int studentCount;
  final String buttonLabel;
  final Function() onButtonPressed;
  final bool isStudent;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
            // course name and type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Gap(8),
                if (miniTitle != null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      miniTitle!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),

            // student count and view feedbacks
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isStudent) ...[
                  const Icon(
                    Icons.person,
                    size: 20,
                  ),
                  const Gap(8),
                  Text(
                    '$studentCount Students',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
                if (child != null) child!,
                const Spacer(),
                GestureDetector(
                  onTap: onButtonPressed,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Text(
                          buttonLabel,
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
            )
          ],
        ),
      ),
    );
  }
}
