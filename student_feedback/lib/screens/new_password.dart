import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import 'package:student_feedback/router/router.dart';
import 'package:student_feedback/screens/fade_animationtest.dart';
import 'package:student_feedback/screens/password_changed.dart';
import 'package:student_feedback/utils/hashing.dart';
import 'package:student_feedback/utils/text_styles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key, required this.email});

  final String email;

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurepasswordText = true;
  bool _obscureconfirmpasswordText = true;
  final _formKey = GlobalKey<FormState>();

  Future<void> _reset() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform password reset logic here
      final supabase = Supabase.instance.client;

      await supabase
          .from('users')
          .update({
            'password_hash': hashPassword(_passwordController.text.trim()),
          })
          .eq('email', widget.email)
          .onError((err, stack) {
            print(err);
          });

      // GoRouter.of(context).pushNamed(Routers.passwordchanges.name);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PasswordChangesPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                          "Create new password",
                          style: titleTheme.copyWith(
                            color: const Color(0xFF731C65),
                          ),
                        ),
                      ),
                      FadeInAnimation(
                        delay: 1.6,
                        child: Text(
                          "Your new password must be unique from those previously used.",
                          style: mediumThemeblack,
                        ),
                      )
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
                              fillColor:
                                  const Color(0xFF731C65).withOpacity(0.1),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: const Color(0xFF731C65), width: 2.0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscurepasswordText =
                                        !_obscurepasswordText;
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
                        const SizedBox(
                          height: 15,
                        ),
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
                              fillColor:
                                  const Color(0xFF731C65).withOpacity(0.1),
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
                        const SizedBox(
                          height: 30,
                        ),
                        FadeInAnimation(
                          delay: 1.8,
                          child: CustomElevatedButton(
                            message: "Reset Password ",
                            function: _reset,
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
      ),
    );
  }
}
