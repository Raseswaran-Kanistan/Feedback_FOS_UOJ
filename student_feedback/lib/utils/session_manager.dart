import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_feedback/router/router.dart';

// Save session
Future<void> saveSession(String userId, String email, String authString) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);
  await prefs.setString('email', email);
  await prefs.setString('auth_string', authString);

  final sessionData = await getSession();
  // print('the session is ${sessionData['email']}');
}

// Get session
Future<Map<String, String?>> getSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');
  String? email = prefs.getString('email');
  String? authString = prefs.getString('auth_string');

  return {'userId': userId, 'email': email, 'auth_string': authString};
}

// Clear session
Future<void> clearSession() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<void> logoutUser(context) async {
  await clearSession();
  GoRouter.of(context).push(Routers.authenticationpage.path);
}
