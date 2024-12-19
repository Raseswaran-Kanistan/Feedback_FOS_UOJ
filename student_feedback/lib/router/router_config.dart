import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:student_feedback/Onboboarding/onboarding_view.dart';
import 'package:student_feedback/dashboard/admin_dashboard.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage1.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage2.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage3.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage4.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage5.dart';
import 'package:student_feedback/feedbackform_practical/feedbackformPage6.dart';
import 'package:student_feedback/feedbackform_theory/feedbackformPage1.dart';
import 'package:student_feedback/feedbackform_theory/feedbackformPage2.dart';
import 'package:student_feedback/feedbackform_theory/feedbackformPage3.dart';
import 'package:student_feedback/feedbackform_theory/feedbackformPage4.dart';
import 'package:student_feedback/feedbackform_theory/feedbackformPage5.dart';
import 'package:student_feedback/feedbackform_theory_and_practical/page1.dart';
import 'package:student_feedback/feedbackform_theory_and_practical/page2.dart';
import 'package:student_feedback/feedbackform_theory_and_practical/page3.dart';
import 'package:student_feedback/feedbackform_theory_and_practical/page4.dart';
import 'package:student_feedback/router/router.dart';
import 'package:student_feedback/screens/authentication_ui.dart';
import 'package:student_feedback/screens/forgetpassword.dart';
import 'package:student_feedback/screens/login_page.dart';
import 'package:student_feedback/screens/new_password.dart';
import 'package:student_feedback/screens/otp_verification.dart';
import 'package:student_feedback/screens/password_changed.dart';
import 'package:student_feedback/screens/register_page.dart';
import 'package:student_feedback/screens/splash_screen.dart';
import '../dashboard/student_dashboard.dart';
import '../dashboard/teacher_dashboard.dart';

final router = GoRouter(initialLocation: Routers.splashscreen.path, routes: [
//final router = GoRouter(routes: [
  GoRoute(
    path: Routers.splashscreen.path,
    name: Routers.splashscreen.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: SplashScreen());
    },
  ),
  GoRoute(
    path: Routers.authenticationpage.path,
    name: Routers.authenticationpage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: AuthenticationUI());
    },
  ),
  GoRoute(
    path: Routers.loginpage.path,
    name: Routers.loginpage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: LoginPage());
    },
  ),
  GoRoute(
    path: Routers.signuppage.path,
    name: Routers.signuppage.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: SignupPage());
    },
  ),
  GoRoute(
    path: Routers.forgetpassword.path,
    name: Routers.forgetpassword.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: ForgetPasswordPage());
    },
  ),
  GoRoute(
    path: Routers.newpassword.path,
    name: Routers.newpassword.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(
          child: NewPasswordPage(
        email: '',
      ));
    },
  ),
  GoRoute(
    path: Routers.otpverification.path,
    name: Routers.otpverification.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: OtpVerificationPage());
    },
  ),
  GoRoute(
    path: Routers.passwordchanges.path,
    name: Routers.passwordchanges.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: PasswordChangesPage());
    },
  ),
  GoRoute(
    path: Routers.onboardingview.path,
    name: Routers.onboardingview.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: OnboardingView());
    },
  ),
  GoRoute(
    path: Routers.feedbackformtheoryPage1.path,
    name: Routers.feedbackformtheoryPage1.name,
    pageBuilder: (context, state) {
      return CupertinoPage(
          child: BothFeedbackPageOne(
        courseID: '',
        courseName: '',
        courseType: '',
      ));
    },
  ),
  GoRoute(
    path: Routers.feedbackformtheoryPage2.path,
    name: Routers.feedbackformtheoryPage2.name,
    pageBuilder: (context, state) {
      return CupertinoPage(
          child: Page2(
        courseID: '',
      ));
    },
  ),
  GoRoute(
    path: Routers.feedbackformtheoryPage3.path,
    name: Routers.feedbackformtheoryPage3.name,
    pageBuilder: (context, state) {
      return CupertinoPage(
          child: Page3(
        formData: {},
        courseID: '',
      ));
    },
  ),
  GoRoute(
    path: Routers.feedbackformtheoryPage4.path,
    name: Routers.feedbackformtheoryPage4.name,
    pageBuilder: (context, state) {
      return CupertinoPage(
          child: Page4(
        formData: {},
        courseID: '',
      ));
    },
  ),
  GoRoute(
    path: Routers.feedbackformtheoryPage5.path,
    name: Routers.feedbackformtheoryPage5.name,
    pageBuilder: (context, state) {
      return CupertinoPage(
          child: Page5(
        formData: {},
        courseID: '',
      ));
    },
  ),
  GoRoute(
    path: Routers.feedbackformPage1.path,
    name: Routers.feedbackformPage1.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(
          child: practicalPage1(
        courseID: '',
        courseName: '',
        courseType: '',
      ));
    },
  ),
  GoRoute(
    path: Routers.feedbackformPage2.path,
    name: Routers.feedbackformPage2.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: practicalPage2());
    },
  ),
  GoRoute(
    path: Routers.feedbackformPage3.path,
    name: Routers.feedbackformPage3.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: practicalPage3(formData: const {}));
    },
  ),
  GoRoute(
    path: Routers.feedbackformPage4.path,
    name: Routers.feedbackformPage4.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: practicalPage4(formData: const {}));
    },
  ),
  GoRoute(
    path: Routers.feedbackformPage5.path,
    name: Routers.feedbackformPage5.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: practicalPage5(formData: const {}));
    },
  ),
  GoRoute(
    path: Routers.feedbackformPage6.path,
    name: Routers.feedbackformPage6.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: practicalPage6(formData: const {}));
    },
  ),
  // GoRoute(
  //     path: Routers.practicalAndTheoryFormPage1.path,
  //     name: Routers.practicalAndTheoryFormPage1.name,
  //     pageBuilder: (context, state) =>
  //         CupertinoPage(child: BothFeedbackPageOne())),
  // GoRoute(
  //     path: Routers.practicalAndTheoryFormPage2.path,
  //     name: Routers.practicalAndTheoryFormPage2.name,
  //     pageBuilder: (context, state) =>
  //         CupertinoPage(child: BothFeedbackPageTwo())),
  // GoRoute(
  //     path: Routers.practicalAndTheoryFormPage3.path,
  //     name: Routers.practicalAndTheoryFormPage3.name,
  //     pageBuilder: (context, state) =>
  //         CupertinoPage(child: BothFeedbackPageThree())),
  // // GoRoute(
  // //     path: Routers.practicalAndTheoryFormPage4.path,
  // //     name: Routers.practicalAndTheoryFormPage4.name,
  // //     pageBuilder: (context, state) =>
  // //         CupertinoPage(child: BothFeedbackPageFour())),
  GoRoute(
    path: Routers.teadashboard.path,
    name: Routers.teadashboard.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: TeacherDashboard());
    },
  ),
  GoRoute(
    path: Routers.studashboard.path,
    name: Routers.studashboard.name,
    pageBuilder: (context, state) {
      return CupertinoPage(child: StudentDashboard());
    },
  ),
  GoRoute(
    path: Routers.admindashboard.path,
    name: Routers.admindashboard.name,
    pageBuilder: (context, state) {
      return const CupertinoPage(child: AdminDashboard());
    },
  ),
]);
