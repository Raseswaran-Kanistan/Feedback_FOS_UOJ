import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    super.key,
    this.height = 38,
  });
  final double height;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
            color: Colors.blue.shade300,
            borderRadius: BorderRadius.circular(50)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 15,
              ),
              Gap(8),
              Text('back'),
            ],
          ),
        ),
      ),
    );
  }
}
