import 'package:eict_spaces_adm/controllers/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


Future<List> getPendingBookings() async {
  var db = FirebaseFirestore.instance;
  var bookings = await db
      .collection('bookings')
      .where('status', isEqualTo: 'PENDING')
      .get();
  print("bookings");
  print(bookings.docs.length);
  print(bookings.docs.length.runtimeType);
  List Solicitudes = await bookings.docs
      .map((e) => [e.data()['space_id'],e.data()['by']['email'], e.data()['by']['name'], e.data()['from'].toDate(),e.data()['to'].toDate(),e.data()['reason'],e.data()['space_id'],e.id ]) //el ultimo existe para borrarlo
      .toList();
  print("Lista de bookings");
  print(Solicitudes);
  var spaces = await db.collection('spaces').get();//hacer esto luego de tener claros los ides de bookings pendientes
  print("Spaces");//ANTES DE ESTO HAY UN ERROR
  print(spaces.docs.length);
  print(spaces.docs.length.runtimeType);
  List Espacios = await spaces.docs.map((e) => [ e.id, e.data()['name'] ,e.data()['location']]).toList(); // El spaceid
  print("Lista espacio");
  print(Espacios);
  //Ahora usamos los ids de ambos lados para conectarlos y tener la reserva con nombre del lab
  for (int i = 0; i< Solicitudes.length; i++ ){
    for(int j = 0; j< Espacios.length;j++){
      if( Solicitudes[i][0]  == Espacios[j][0] ){ //la pose 0 tiene los ids de espacios y 0 id de espacios
        print("encontre un espacio");
        Solicitudes[i][0] = Espacios[j][1]; //Si coinciden reemplazo el nombre por id
        Solicitudes[i][6] = Espacios[j][2];
      }
    }
  }
  //Ahora solicitudes tiene nombreEspacio,correo,nombre,desde,hasta
  print("Solicitudes");
  print(Solicitudes);
  print(Solicitudes.length);
  print(Solicitudes.length.runtimeType);
  return Solicitudes;
}


class _MyHomePageState extends State<MyHomePage> {
  final mainController controller = Get.put(mainController());
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 10));
          setState(() {});
        },
        child: FutureBuilder(
          future: getPendingBookings(),
          builder: (context, snapshot) {
            List? reservas = snapshot.data; //ya esta en lista de la función
            return ListView(
              //ademas aceptar o quitar las quita de la lista, puede ser refrescar y volver a cargar todo desde la base de datos
                children:
                List.generate(
                  reservas!.length, //datos del snapshot
                      (index) => GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: SingleChildScrollView(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 20,
                                  bottom: 20,
                                ),
                                margin: const EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 150,
                                  bottom: 150,
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(2, 2),
                                      blurRadius: 20,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'Detalles de la reserva',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Nombre: ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                reservas[index][2], //list[index][by][name]
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                'Espacio: ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                //reservas[index]['space_id'], //list[index][space_id]
                                                reservas[index][0],
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                'Fecha reserva: ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  reservas[index][3].toString() + " - " + reservas[index][4].toString(), //list[index][from] y list[index][to]
                                                  style:
                                                  TextStyle(fontSize: 16),
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Razón de la reserva: ',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                    padding:const EdgeInsets.all(20),
                                                    child:  Text(
                                                      reservas[index][5], //list[index][by][email]
                                                      style: TextStyle(fontSize: 16),
                                                      ),
                                                )
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Lógica
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.green,
                                                  foregroundColor: Colors.white,
                                                  textStyle:
                                                  TextStyle(fontSize: 16),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                  ),
                                                ),
                                                child: Text('Aceptar'),
                                              ),
                                              SizedBox(width: 15),
                                              ElevatedButton(
                                                onPressed: () {
                                                  controller.sendMail();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  textStyle:
                                                  TextStyle(fontSize: 16),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 12),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        8),
                                                  ),
                                                ),
                                                child: Text('Rechazar'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: FlutterLogo(size: 72.0),
                        title: Text(reservas[index][0]),
                        subtitle: Text(reservas[index][3].month.toString()+ "/" +reservas[index][3].day.toString()+ " "+reservas[index][3].hour.toString()+":"+reservas[index][3].minute.toString()+ "-" + reservas[index][4].hour.toString()+":"+reservas[index][4].minute.toString()), //list[index][from] y list[index][to]
                        trailing: Icon(Icons.more_vert),//Aqui poner la foto del espacio correspondiente
                        isThreeLine: true,
                      ),
                    ),
                  ),
                )
            );
          },
        ),
// This trailing comma makes auto-formatting nicer for build methods.
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("calendario"),
        tooltip: 'Increment', //buscar un icono como un calendario
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}


class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.status, this.reason, this.by, this.spaceId,
      [this.bookingId = ""]);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;

  String status;

  String reason;

  Map by;

  String spaceId;

  String bookingId;
}
