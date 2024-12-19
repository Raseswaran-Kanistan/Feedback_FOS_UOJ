class AppRouter {
  String name;
  String path;
  AppRouter({
    required this.name,
    required this.path,
  });
}

class Routers {
  static AppRouter splashscreen = AppRouter(name: "/", path: "/");
  static AppRouter authenticationpage =
      AppRouter(name: "/authentication", path: "/authentication");
  static AppRouter loginpage = AppRouter(name: "/login", path: "/login");
  static AppRouter signuppage = AppRouter(name: "/signup", path: "/signup");
  static AppRouter forgetpassword =
      AppRouter(name: "/forgetpassword", path: "/forgetpassword");
  static AppRouter newpassword =
      AppRouter(name: "/newpassword", path: "/newpassword");
  static AppRouter otpverification =
      AppRouter(name: "/otpverification", path: "/otpverification");
  static AppRouter passwordchanges =
      AppRouter(name: "/passwordchanges", path: "/passwordchanges");
  static AppRouter onboardingview =
      AppRouter(name: "/onboardingview", path: "/onboardingview");
  static AppRouter feedbackformtheoryPage1 =
      AppRouter(name: "/Page1", path: "/Page1");
  static AppRouter feedbackformtheoryPage2 =
      AppRouter(name: "/Page2", path: "/Page2");
  static AppRouter feedbackformtheoryPage3 =
      AppRouter(name: "/Page3", path: "/Page3");
  static AppRouter feedbackformtheoryPage4 =
      AppRouter(name: "/Page4", path: "/Page4");
  static AppRouter feedbackformtheoryPage5 =
      AppRouter(name: "/Page5", path: "/Page5");
  static AppRouter feedbackformPage1 =
      AppRouter(name: "/practicalPage1", path: "/practicalPage1");
  static AppRouter feedbackformPage2 =
      AppRouter(name: "/practicalPage2", path: "/practicalPage2");
  static AppRouter feedbackformPage3 =
      AppRouter(name: "/practicalPage3", path: "/practicalPage3");
  static AppRouter feedbackformPage4 =
      AppRouter(name: "/practicalPage4", path: "/practicalPage4");
  static AppRouter feedbackformPage5 =
      AppRouter(name: "/practicalPage5", path: "/practicalPage5");
  static AppRouter feedbackformPage6 =
      AppRouter(name: "/practicalPage6", path: "/practicalPage6");
  static AppRouter practicalAndTheoryFormPage1 =
      AppRouter(name: "/theoryAndPracticalOne", path: "/theoryAndPracticalOne");
  static AppRouter practicalAndTheoryFormPage2 =
      AppRouter(name: "/theoryAndPracticalTwo", path: "/theoryAndPracticalTwo");
  static AppRouter practicalAndTheoryFormPage3 = AppRouter(
      name: "/theoryAndPracticalThree", path: "/theoryAndPracticalThree");
  static AppRouter practicalAndTheoryFormPage4 = AppRouter(
      name: "/theoryAndPracticalFour", path: "/theoryAndPracticalFour");
  static AppRouter practicalAndTheoryFormPage5 = AppRouter(
      name: "/theoryAndPracticalFive", path: "/theoryAndPracticalFive");
  static AppRouter practicalAndTheoryFormPage6 =
      AppRouter(name: "/theoryAndPracticalSix", path: "/theoryAndPracticalSix");
  static AppRouter teadashboard =
      AppRouter(name: "/TeacherDashboard", path: "/TeacherDashboard");
  static AppRouter studashboard =
      AppRouter(name: "/StudentDashboard", path: "/dashboard/StudentDashboard");
  static AppRouter admindashboard =
      AppRouter(name: "/AdminDashboard", path: "/AdminDashboard");
}
