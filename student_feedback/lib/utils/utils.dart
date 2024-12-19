import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:student_feedback/screens/register_page.dart';

Future<void> sendOTPEmail({
  required String recipient,
  required String otp,
  bool forgot = false,
}) async {
  await dotenv.load(fileName: ".env");

  final smtpServer = SmtpServer(
    dotenv.env['SMTP_SERVER']!,
    port: int.tryParse(dotenv.env['SMTP_PORT']!) ?? 587,
    username: dotenv.env['SMTP_USER']!,
    password: dotenv.env['MAIL_APP_PASSWORD']!,
  );

  var messageBody = forgot
      ? 'A One Time Password (OTP) has been requested to your email. Use the following OTP to reset your password.'
      : 'Thank you for registering for the student feedback system. Use the following OTP to complete your sign-up procedure.';

  final message = Message()
    ..from = const Address('uojstdfeedback@gmail.com', 'support')
    ..recipients.add(recipient)
    ..subject = 'Your confirmation code!'
    ..text = 'Use this code to verify your email: $otp'
    ..html = '''
<div style="font-family: Helvetica, Arial, sans-serif; max-width: 600px; margin: 0 auto; overflow: auto; line-height: 2; padding: 20px;">
  <div style="border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px;">
    <a href="#" style="font-size: 1.4em; color: #00466a; text-decoration: none; font-weight: 600;"> UOJ FOS Student Feedback System</a>
  </div>
  <p style="font-size: 1.1em;">Hi,</p>
  <p>$messageBody The OTP is valid for 5 minutes.</p>
  <h2 style="background: #00466a; width: fit-content; padding: 0 10px; color: #fff; border-radius: 4px; margin: 20px 0;">$otp</h2>
  <p style="font-size: 0.9em;">Regards,<br /> UOJ FOS Student Feedback System</p>
  <hr style="border: none; border-top: 1px solid #eee;" />
  <div style="color: #aaa; font-size: 0.8em; line-height: 1.5; font-weight: 300;">
    <p>UOJ FOS Student Feedback System</p>
    <p>University of Jaffna</p>
    <p>Sri Lanka</p>
  </div>
</div>
''';
  try {
    final sendReport = await send(message, smtpServer);
    // print('Message sent: $sendReport');
  } catch (e) {
    // print('Error occurred while sending email: $e');
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Center(
        child: Text(
      message,
      style: const TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    )),
    backgroundColor: const Color(0xFF731C65),
  ));
}

Future<bool?> confirmAction(
    String title, String content, BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(title),
      content: Text(content),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          height: 49,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
              // backgroundColor: Colors.greenAccent,
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
        ),
        CustomElevatedButton(
          color: Colors.redAccent,
          width: MediaQuery.of(context).size.width * 0.3,
          function: () => Navigator.pop(context, true),
          message: 'Yes',
        ),
      ],
    ),
  );
}

bool isFirstCharVowel(String value) =>
    ['a', 'e', 'i', 'o', 'u'].contains(value[0]);
