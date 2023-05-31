import 'package:get/get.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';

class mainController extends GetxController{
  
  void sendMail() async {
  final mailer = Mailer('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');
  final toAddress = Address('juanluis0217@gmail.com');
  final fromAddress = Address('juanl.avila@urosario.edu.co');
  final content = Content('text/plain', 'Su reserva ha sido confirmada exitosamente.');
  final subject = 'Reserva de espacio confirmada';
  final personalization = Personalization([toAddress]);

  final email =
      Email([personalization], fromAddress, subject, content: [content]);
  mailer.send(email).then((result) {
    print(result.isValue);
  });
  }
}