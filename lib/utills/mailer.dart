import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';//For creating the SMTP Server

void mailer(String mailto, String body) async {
  String username = "subhajit.dey4486@gmail.com";//Your Email;
  String password = "01817472";//Your Email's password;

  final smtpServer = gmail(username, password); 
  // Creating the Gmail server

  // Create our email message.
  final message = Message()
    ..from = Address('Veggy')
    ..recipients.add(mailto.trim()) //recipent email
    // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
    // ..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
    ..subject = 'Veggy verfication mail' //subject of the email
    ..text = body; //body of the email

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString()); //print if the email is sent
  } on MailerException catch (e) {
    print('Message not sent. \n'+ e.toString()); //print if the email is not sent
    // e.toString() will show why the email is not sending
  }
} 