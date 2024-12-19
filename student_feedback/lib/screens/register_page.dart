// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:student_feedback/screens/fade_animationtest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/screens/otp_verification.dart';
import 'package:student_feedback/utils/hashing.dart';
import 'package:student_feedback/utils/text_styles.dart';
import 'package:student_feedback/utils/utils.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import '../router/router.dart';
// import '../services/supabase_services.dart';

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
  final double? width;
  final Color? textColor;

  const CustomElevatedButton({
    Key? key,
    required this.message,
    required this.function,
    this.color,
    this.textColor,
    this.width = 300,
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
          fixedSize: WidgetStatePropertyAll(Size.fromWidth(widget.width!)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 15),
          ),
          backgroundColor: WidgetStatePropertyAll(
            widget.color ?? Color(0xFF731C65),
          )),
      child: loading
          ? const CupertinoActivityIndicator()
          : FittedBox(
              child: Text(
              widget.message,
              style: semiboldwhite.copyWith(
                color: widget.textColor ?? Colors.white,
              ),
            )),
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurepasswordText = true;
  bool _obscureconfirmpasswordText = true;

  _verifyEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      // generate a fourt digit random number
      var rng = Random();
      int otp = rng.nextInt(9000) + 1000;
      DateTime expiryTime = DateTime.now().add(const Duration(minutes: 5));
      String expiryTimeString = expiryTime.toIso8601String();

      final supabase = Supabase.instance.client;

      // final response = await supabase.from('users').select().or(
      //     'id.eq.${_registrationNumberController.text.trim()}, email.eq.${_emailController.text.trim()}');
      final response = await supabase
          .from('users')
          .select()
          .eq('email', _emailController.text.trim())
          .eq('id', _registrationNumberController.text.trim());

      if (response.isEmpty) {
        showMessage(context,
            'No User found! Check your Id and Email with System Admin!');
        return;
      }

      if (response.isNotEmpty) {
        if (response[0]['password_hash'] != null) {
          showMessage(context, 'User already registered!');
          return;
        }
      }

      await supabase
          .from('users')
          .update({'otp': otp, 'otp_expiry': expiryTimeString}).eq(
              'email', _emailController.text.trim());

      sendOTPEmail(
        recipient: _emailController.text.trim(),
        otp: otp.toString(),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OtpVerificationPage(
            onSuccess: _register,
            otp: otp,
            goRouteRouteName: Routers.loginpage.name,
          ),
        ),
      );
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      final supabase = Supabase.instance.client;

      // print(
      //     'password hash is ${hashPassword(_passwordController.text.trim())}');
      await supabase.from('users').update({
        'password_hash': hashPassword(_passwordController.text.trim()),
        'name': _usernameController.text.trim(),
      }).eq('id', _registrationNumberController.text.trim());
      showMessage(context,
          'Registration successful! Please login with your credentials!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeInAnimation(
                delay: 0.6,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FadeInAnimation(
                      delay: 1.3,
                      child: Text(
                        " Register",
                        style: titleTheme.copyWith(
                          color: const Color(0xFF731C65),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FadeInAnimation(
                        delay: 1.5,
                        child: CustomTextFormField(
                          controller: _registrationNumberController,
                          hinttext: 'Registration Number',
                          obsecuretext: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Reg.Number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      FadeInAnimation(
                        delay: 1.5,
                        child: CustomTextFormField(
                          controller: _usernameController,
                          hinttext: 'Username',
                          obsecuretext: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      FadeInAnimation(
                        delay: 1.8,
                        child: CustomTextFormField(
                          controller: _emailController,
                          hinttext: 'Email',
                          obsecuretext: false,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter your email';
                          //   } else if (!RegExp(r'\S+@\S+\.\S+')
                          //       .hasMatch(value)) {
                          //     return 'Please enter a valid email';
                          //   }
                          //   return null;
                          // },
                          validator: (value) {
                            // Trim leading and trailing whitespace
                            String trimmedValue = value?.trim() ?? '';

                            // Check if the field is empty
                            if (trimmedValue.isEmpty) {
                              return 'Please enter your email';
                            }

                            // Regular expression for validating email
                            final emailRegExp = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              caseSensitive: false,
                              multiLine: false,
                            );

                            // Validate email format
                            if (!emailRegExp.hasMatch(trimmedValue)) {
                              return 'Please enter a valid email';
                            }

                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      FadeInAnimation(
                        delay: 2.2,
                        child: TextFormField(
                          enableInteractiveSelection: false,
                          controller: _passwordController,
                          obscureText: _obscurepasswordText,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: "Password",
                            hintStyle: hinttext,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: const Color(0xFF731C65).withOpacity(0.1),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: const Color(0xFF731C65), width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurepasswordText = !_obscurepasswordText;
                                });
                              },
                              icon: Icon(
                                _obscurepasswordText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF731C65),
                              ),
                            ),
                          ),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter your password';
                          //   }
                          //   return null;
                          // },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (!RegExp(
                                    r'^(?=.*[A-Z])(?=.*[!@#\$&*~])(?=.*[0-9]).{8,15}$')
                                .hasMatch(value)) {
                              return 'Password must contain at least:\n- One uppercase letter\n- One special character\n- One number\n- 8-15 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      FadeInAnimation(
                        delay: 2.2,
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureconfirmpasswordText,
                          enableInteractiveSelection: false,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(18),
                            hintText: "Confirm Password",
                            hintStyle: hinttext,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none),
                            fillColor: const Color(0xFF731C65).withOpacity(0.1),
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: const Color(0xFF731C65), width: 2.0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureconfirmpasswordText =
                                      !_obscureconfirmpasswordText;
                                });
                              },
                              icon: Icon(
                                _obscureconfirmpasswordText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF731C65),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            } else if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 50),
                      FadeInAnimation(
                        delay: 2.7,
                        child: CustomElevatedButton(
                          message: "Register",
                          function: _verifyEmail,
                          color: const Color(0xFF731C65),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              FadeInAnimation(
                delay: 3.6,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: hinttext,
                      ),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(Routers.loginpage.name);
                        },
                        child: Text(
                          "Login Now",
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
