import 'package:get/get.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:flutter/services.dart' show rootBundle;

class mainController extends GetxController{
  
  void sendMail() async {
  final mailer = Mailer('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');
  final toAddress = Address('juanluis0217@gmail.com');
  const fromAddress = Address('juanl.avila@urosario.edu.co');

  final htmlTemplate = await rootBundle.loadString('assets/email_templates/reservation_accepted.html');

  final content = Content('text/html', htmlTemplate);
  const subject = 'Reserva de espacio confirmada';
  final personalization = Personalization([toAddress]);

  final email =
      Email([personalization], fromAddress, subject, content: [content]);
  mailer.send(email).then((result) {
    print(result.isValue);
  });
  }
}