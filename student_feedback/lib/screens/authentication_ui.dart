import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:student_feedback/router/router.dart';
import 'package:student_feedback/screens/fade_animationtest.dart';
import 'package:student_feedback/utils/text_styles.dart';

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

class AuthenticationUI extends StatefulWidget {
  const AuthenticationUI({super.key});

  @override
  State<AuthenticationUI> createState() => _AuthenticationUIState();
}

class _AuthenticationUIState extends State<AuthenticationUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SizedBox(
              child: Column(
                children: [
                  FadeInAnimation(
                    delay: 1,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/images/logo.png"))),
                    ),
                  ),
                  const FadeInAnimation(
                    delay: 1.5,
                    child: Center(
                      child: Text(
                        "Faculty of Science,UOJ",
                        style: TextStyle(
                            fontSize: 26,
                            fontFamily: "Urbanist",
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  FadeInAnimation(
                    delay: 2,
                    child: CustomElevatedButton(
                      message: "Login",
                      function: () {
                        GoRouter.of(context).pushNamed(Routers.loginpage.name);
                      },
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FadeInAnimation(
                    delay: 2,
                    child: ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context)
                              .pushNamed(Routers.signuppage.name);
                        },
                        style: ButtonStyle(
                            side: const WidgetStatePropertyAll(
                                BorderSide(color: Colors.black)),
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            fixedSize: const WidgetStatePropertyAll(
                                Size.fromWidth(300)),
                            padding: const WidgetStatePropertyAll(
                              EdgeInsets.symmetric(vertical: 20),
                            ),
                            backgroundColor:
                                const WidgetStatePropertyAll(Colors.white)),
                        child: const Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Urbanist-SemiBold",
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
