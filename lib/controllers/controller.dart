import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:sendgrid_mailer/sendgrid_mailer.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;
import 'package:intl/date_symbol_data_local.dart';

class mainController extends GetxController{
  String _mailerKey = "";

  @override
  void onInit() {
    super.onInit();
    getEmailKey();
  }

  void setMailerKey(String newValue){
    _mailerKey = newValue;
  }

  Future<void> getEmailKey() async {
    var db = FirebaseFirestore.instance;
    var emailKey = await db
        .collection('ulitities')
        .where('name', isEqualTo: 'emailkey')
        .get();
    // print("Traer key");
    // print(emailKey.docs);
    setMailerKey(emailKey.docs[0]['value']);
  }

  void sendConfirmationMail(nombre,espacio,fecha,location,String userEmail) async {
    final mailer = Mailer(_mailerKey);
    final toAddress = Address(userEmail);
    const fromAddress = Address('guillermo.ribero@urosario.edu.co');
    final htmlTemplate = await rootBundle.loadString('assets/email_templates/reservation_accepted.html');
    final modifiedHTMLTemplate = htmlTemplate
        .replaceAll('[Nombre]', nombre)
        .replaceAll('[Espacio]', espacio)
        .replaceAll('[Fecha]', fecha)
        .replaceAll('[Location]', location);

    final content = Content('text/html', modifiedHTMLTemplate);
    const subject = 'Reserva de espacio confirmada';
    final personalization = Personalization([toAddress]);

    Uint8List logoImageBytes = (await rootBundle.load('assets/img/logo_ur.png')).buffer.asUint8List();
    String based64Logo = base64Encode(logoImageBytes);

    final email =
        Email([personalization], fromAddress, subject, content: [content],
        attachments: [
        Attachment(
          based64Logo, 'logo.png', contentId: "logo"
      ), 
    ]);
    mailer.send(email).then((result) {
      print("Email");
      print(userEmail);
      print(result.isValue);
    });
  }

  void sendRejectionMail(nombre,espacio,fecha,location,String userEmail) async {
    final mailer = Mailer(_mailerKey);
    final toAddress = Address(userEmail);
    const fromAddress = Address('guillermo.ribero@urosario.edu.co');
    final htmlTemplate = await rootBundle.loadString('assets/email_templates/reservation_rejected.html');
    final modifiedHTMLTemplate = htmlTemplate
        .replaceAll('[Nombre]', nombre)
        .replaceAll('[Espacio]', espacio)
        .replaceAll('[Fecha]', fecha)
        .replaceAll('[Location]', location);

    final content = Content('text/html', modifiedHTMLTemplate);
    const subject = 'Reserva de espacio rechazada';
    final personalization = Personalization([toAddress]);

    Uint8List logoImageBytes = (await rootBundle.load('assets/img/logo_ur.png')).buffer.asUint8List();
    String based64Logo = base64Encode(logoImageBytes);
    
    final email =
        Email([personalization], fromAddress, subject, content: [content],
        attachments: [
        Attachment(
          based64Logo, 'logo.png', contentId: "logo"
      ), 
    ],);
    mailer.send(email).then((result) {
      print("Email");
      print(userEmail);
      print(result.isValue);
    });
  }

  String formatDateRange(DateTime start, DateTime end) {    
    initializeDateFormatting();
    DateFormat dateFormat = DateFormat('EEEE d', 'es');
    DateFormat monthFormat = DateFormat('MMMM', 'es');
    DateFormat timeFormat = DateFormat('HH:mm');
    String startDate = dateFormat.format(start);
    startDate = startDate.replaceFirst(startDate[0], startDate[0].toUpperCase());
    String month = monthFormat.format(start);
    String startTime = timeFormat.format(start);
    String endTime = timeFormat.format(end);

  return '$startDate de $month $startTime - $endTime';
}    
}  