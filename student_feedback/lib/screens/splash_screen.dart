import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/router/router.dart';
import 'package:student_feedback/utils/session_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToAuthenticate();
    });
  }

  getUserData() async {
    final storedData = await getSession();

    if (storedData['email'] == null) {
      context.go(Routers.authenticationpage.path);
      return null;
    }

    final supabase = Supabase.instance.client;
    final userData = supabase
        .from('users')
        .select()
        .eq('email', storedData['email']!)
        .single();
    return userData;
  }

  void _navigateToAuthenticate() async {
    final userData = await getUserData();
    if (userData == null) return;

    String initialPage;
    switch (userData['role']) {
      case 'student':
        initialPage = Routers.studashboard.path;
        break;
      case 'lecturer':
        initialPage = Routers.teadashboard.path;
        break;
      case 'admin':
        initialPage = Routers.admindashboard.path;
        break;
      default:
        initialPage = Routers.authenticationpage.path;
    }

    GoRouter.of(context).pushReplacement(initialPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3831ee),
              Color(0xFF731C65),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: const Column(
          children: [
            Expanded(
              child: Center(
                child: Icon(
                  Icons.feedback,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'from',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'It Elites',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
