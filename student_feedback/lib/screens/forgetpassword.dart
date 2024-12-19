import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/router/router.dart';
import 'package:student_feedback/screens/fade_animationtest.dart';
import 'package:student_feedback/screens/new_password.dart';
import 'package:student_feedback/screens/otp_verification.dart';
import 'dart:async';

import 'package:student_feedback/utils/text_styles.dart';
import 'package:student_feedback/utils/utils.dart';

class CustomTextFormField extends StatefulWidget {
  final String hinttext;
  final bool obsecuretext;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const CustomTextFormField({
    Key? key,
    required this.hinttext,
    required this.obsecuretext,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obsecuretext,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(18),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
        fillColor: const Color(0xFF731C65).withOpacity(0.1),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: const Color(0xFF731C65), width: 2.0),
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hinttext,
        hintStyle: hinttext,
      ),
      validator: widget.validator,
    );
  }
}

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

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(
                      delay: 1.3,
                      child: Text(
                        "Forgot Password?",
                        style: titleTheme.copyWith(
                          color: const Color(0xFF731C65),
                        ),
                      ),
                    ),
                    FadeInAnimation(
                      delay: 1.6,
                      child: Text(
                        "Don't worry! It occurs. Please enter the email address linked with your account.",
                        style: mediumThemeblack,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        delay: 1.9,
                        child: CustomTextFormField(
                          hinttext: 'Enter your email',
                          controller: _emailTextController,
                          obsecuretext: false,
                          validator: (value) {
                            String trimmedValue = value?.trim() ?? '';

                            if (trimmedValue.isEmpty) {
                              return 'Please enter your email';
                            }

                            final emailRegExp = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              caseSensitive: false,
                              multiLine: false,
                            );

                            if (!emailRegExp.hasMatch(trimmedValue)) {
                              return 'Please enter a valid email';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      FadeInAnimation(
                        delay: 2.1,
                        child: CustomElevatedButton(
                          message: "Send Code",
                          function: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              // generate a random 4digit otp and send email

                              final int otp =
                                  Random().nextInt(9999 - 1000) + 1000;

                              sendOTPEmail(
                                recipient: _emailTextController.text,
                                otp: otp.toString(),
                                forgot: true,
                              );

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpVerificationPage(
                                            email: _emailTextController.text,
                                            otp: otp,
                                            onSuccess: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NewPasswordPage(
                                                            email:
                                                                _emailTextController
                                                                    .text,
                                                          )));
                                            },
                                          )));
                            }
                          },
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 300),
              FadeInAnimation(
                delay: 2.4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Remember Password?",
                        style: hinttext,
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(Routers.loginpage.name);
                        },
                        child: Text(
                          "Login",
                          style: mediumTheme.copyWith(
                            color: Color(0xFF3831ee),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
