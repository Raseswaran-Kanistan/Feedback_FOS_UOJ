import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/router/router.dart';
import 'package:student_feedback/screens/fade_animationtest.dart';
import 'package:student_feedback/screens/new_password.dart';
import 'dart:async';

import 'package:student_feedback/utils/text_styles.dart';
import 'package:student_feedback/utils/utils.dart';

class CustomElevatedButton extends StatefulWidget {
  final String message;
  final FutureOr<void> Function() function;
  final Color? color;

  const CustomElevatedButton({
    Key? key,
    required this.message,
    required this.function,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  State<CustomElevatedButton> createState() => _CustomElevatedButtonState();
}

class _CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          loading = true;
        });

        try {
          // ignore: unnecessary_null_comparison
          if (widget.function != null) {
            await widget.function();
          }
        } catch (e) {
          // print("Error executing function: $e");
        }

        setState(() {
          loading = false;
        });
      },
      style: ButtonStyle(
          shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          fixedSize: const WidgetStatePropertyAll(Size.fromWidth(300)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 15),
          ),
          backgroundColor: const WidgetStatePropertyAll(
            Color(0xFF731C65),
          )),
      child: loading
          ? const CupertinoActivityIndicator()
          : FittedBox(
              child: Text(
              widget.message,
              style: semiboldwhite,
            )),
    );
  }
}

class OtpVerificationPage extends StatefulWidget {
  OtpVerificationPage({
    super.key,
    this.onSuccess,
    this.otp,
    this.goRouteRouteName,
    this.email,
  });

  final Function? onSuccess;
  int? otp;
  final String? goRouteRouteName;
  final String? email;

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final TextEditingController _otpTextController = TextEditingController();
  late Timer _countdownTimer;
  int timer = 30;

  Future<void> _handleResendCode() async {
    // Display a confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resend Verification Code'),
          content: const Text('Do you want to resend the verification code?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // User does not want to resend
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User wants to resend
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    // If the user confirmed, resend the code
    if (confirm == true) {
      final int otp = Random().nextInt(9999 - 1000) + 1000;

      sendOTPEmail(
        recipient: widget.email!,
        otp: otp.toString(),
        forgot: true,
      );

      setState(() {
        widget.otp = otp;
        timer = 30;
        _countdownTimer.cancel();
        _reduceTimer();
      });
      // Code to resend the verification code
      // You might call an API or trigger an action to resend the code here
      // print("Resending verification code...");

      // For demonstration purposes, we’ll just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification code has been resent.')),
      );
    }
  }

  void _verifyOTP() {
    if (_otpTextController.text.toString() == widget.otp.toString()) {
      widget.onSuccess!();
    } else {
      showMessage(context, 'Invalid OTP');
      return;
    }
    // GoRouter.of(context)
    //     .pushNamed( ?? Routers.newpassword.name);

    if (widget.goRouteRouteName != null) {
      GoRouter.of(context).pushNamed(widget.goRouteRouteName!);
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => NewPasswordPage(
          email: widget.email!,
        ),
      ));
    }
  }

  void _reduceTimer() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (this.timer <= 0) {
        // Cancel the timer if it reaches zero
        timer.cancel();
      } else {
        setState(() {
          this.timer = this.timer - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _reduceTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('The otp from the previous screen is ${widget.otp}');
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF731C65)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: const Color(0xFF731C65),
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color(0xFF731C65).withOpacity(0.1),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInAnimation(
                delay: 1,
                child: IconButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    icon: const Icon(
                      CupertinoIcons.back,
                      size: 35,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      delay: 1.3,
                      child: Text(
                        "OTP Verification",
                        style: titleTheme.copyWith(
                          color: const Color(0xFF731C65),
                        ),
                      ),
                    ),
                    FadeInAnimation(
                      delay: 1.6,
                      child: Text(
                        "Enter the verification code we just sent on your email address.",
                        style: mediumThemeblack,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 50),
                child: Center(
                  child: Form(
                    child: Column(
                      children: [
                        FadeInAnimation(
                          delay: 1.9,
                          child: Pinput(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            validator: (s) {
                              return s == widget.otp.toString()
                                  ? null
                                  : 'Pin is incorrect';
                            },
                            pinputAutovalidateMode:
                                PinputAutovalidateMode.onSubmit,
                            showCursor: true,
                            onCompleted: (pin) {
                              _otpTextController.text = pin;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        FadeInAnimation(
                          delay: 2.1,
                          child: CustomElevatedButton(
                            message: "Verify",
                            function: _verifyOTP,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 300),
              FadeInAnimation(
                delay: 2.4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't receive code?",
                        style: hinttext,
                      ),
                      TextButton(
                        onPressed: timer > 0
                            ? null // Disable button while timer is active
                            : _handleResendCode,
                        child: InkWell(
                          onTap: () {
                            if (timer > 0) return;
                            _handleResendCode();
                          },
                          child: Text(
                            "Resend",
                            style: mediumTheme.copyWith(
                              color: timer > 0
                                  ? Colors.grey
                                      .shade400 // Greyed-out when timer active
                                  : const Color(
                                      0xFF3831ee), // Active when timer reaches 0
                            ),
                          ),
                        ),
                      ),
                      // Timer display updated dynamically
                      if (timer > 0)
                        Text(
                          '(${timer.toString()})',
                          style: hinttext,
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
