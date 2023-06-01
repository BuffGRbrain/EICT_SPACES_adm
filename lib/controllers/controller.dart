import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:flutter/services.dart' show rootBundle;

class mainController extends GetxController{
  String mailerKey = "";
  Future<String> getEmailKey() async {
    var db = FirebaseFirestore.instance;
    var emailKey = await db
        .collection('utilites')
        .where('name', isEqualTo: 'emailkey')
        .get();
    mailerKey = emailKey.docs[0]['value'];
    return emailKey.docs[0]['value'];
  }

  void sendMail() async {
  final mailer = Mailer(mailerKey);
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