// import 'onboarding_info.dart';


 class OnboardingInfo{
  final String title;
  final String descriptions;
  final String image;

  OnboardingInfo({required this.title, required this.descriptions, required this.image});
 }

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: "Welcome to Feedback App!",
        descriptions:
            " We're excited to have you! Our app is designed to make giving and receiving feedback easy and effective.",
        image: "assets/images/onboard1.gif"),
    OnboardingInfo(
        title: "Discover Our Features",
        descriptions:
            "Easily submit feedback by rating, commenting, or suggesting improvements. See how our app helps you make your voice heard.",
        image: "assets/images/onboard2.gif"),
    OnboardingInfo(
        title: "Confidential Feedback",
        descriptions:
            " Rest assured, your feedback is completely anonymous and confidential. We are committed to protecting your privacy.",
        image: "assets/images/onboard3.gif"),
    OnboardingInfo(
        title: "Ready to Get Started?",
        descriptions:
            "Tap ‘Get Started’ to share your feedback for your courses. Your input helps us improve and deliver better experiences.",
        image: "assets/images/onboard4.gif"),
  ];
}
