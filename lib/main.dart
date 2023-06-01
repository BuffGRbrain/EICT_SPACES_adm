import 'package:eict_spaces_adm/controllers/controller.dart';
import 'package:eict_spaces_adm/pages/CurrentAppointments.dart';
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
      home: const MyHomePage(title: 'Lista de solicitudes de espacios'),
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
          await Future.delayed(const Duration(seconds: 1));
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
                                                  updateEvent(reservas[index][7], "APPROVED");
                                                  deleteCollision(reservas[index][3],reservas[index][4],reservas,reservas[index][7]);
                                                  Navigator.pop(context);//Debe cerrar el dialog
                                                  setState(() {});
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
                                                  updateEvent(reservas[index][7], "DENIED");
                                                  Navigator.pop(context);//Debe cerrar el dialog
                                                  setState(() {});
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CurrentApointments()),
          );
        },
        tooltip: 'Increment', //buscar un icono como un calendario
        child: const Icon(Icons.calendar_month),
      ),
    );
  }
}


//approved es un booleano para ver si se aprobo o nego
Future<void> updateEvent(id, data) {
  CollectionReference users = FirebaseFirestore.instance.collection('bookings');
    //Espacio para negar las que tienen conflicto
    return users
        .doc(id)
        .update({'status':data}) //{key1: val1}
        .then((value) => print("Event Updated"))
        .catchError((error) => print("Failed to update event: $error"));
}

//reservas son las pending y uso el id para actualizarlas
Future<void> deleteCollision(from,to,reservas,id) async {//from, to son date e id es el de la actual para no borrarla accidentalmente
  for(var i in reservas){
    if(i[7] != id ){ //si no es la que acabo de aceptar buscar colisiones y matarlas
      print("Entramos en el if de colisiones");
      // var aux = to.isBefore( i[3]  ); //es un booleano
      // var aux2 = from.isAfter(i[3]);
      // var aux3 = to.isBefore( i[4]  ); //es un booleano
      // var aux4 = from.isAfter(i[4]);

      var aux = from.isBefore( i[3]  ); //es un booleano
      var aux2 = to.isAfter(i[3]);
      var aux3 = from.isBefore( i[4]  ); //es un booleano
      var aux4 = to.isAfter(i[4]);

      if( (aux && aux2) || (aux3 && aux4) ){ //si esta en el rango de reserva la matamos sea la de inicio o la de fin
        print("Se encontro una colision");
        updateEvent(i[7], "DENIED");
      }
      else if( ( to.isAtSameMomentAs(i[4])  ) || (from.isAtSameMomentAs(i[3])) ){ //caso para cuadno el inicio o el final son iguales
        print("Se encontro una colision");
        updateEvent(i[7], "DENIED");
      }
    }
  }
}

