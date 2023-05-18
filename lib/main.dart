import 'package:flutter/material.dart';

void main() {
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

class _MyHomePageState extends State<MyHomePage> {
  var numSolicitudes = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        //ademas aceptar o quitar las quita de la lista, puede ser refrescar y volver a cargar todo desde la base de datos
        children: [
          ...List.generate(
            numSolicitudes,
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
                                    fontSize: 22, fontWeight: FontWeight.w600),
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
                                          'Guillermo Ribero',
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
                                          'Laboratorio Tesla',
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
                                        Text(
                                          'Lunes 22 de mayo 3:00 p.m. - 5:00 p.m.',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            // Lógica
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            textStyle: TextStyle(fontSize: 16),
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text('Aceptar'),
                                        ),
                                        SizedBox(width: 15),
                                        ElevatedButton(
                                          onPressed: () {
                                            //Lógica
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            textStyle: TextStyle(fontSize: 16),
                                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
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
                  title: Text('Three-line ListTile'),
                  subtitle: Text(
                      'A sufficiently long subtitle warrants three lines.'),
                  trailing: Icon(Icons.more_vert),
                  isThreeLine: true,
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("Puto el que lo lea y puto felipe"),
        tooltip: 'Increment', //buscar un icono como un calendario
        child: const Icon(Icons.calendar_month),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
