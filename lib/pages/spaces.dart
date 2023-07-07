import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eict_spaces_adm/controllers/controller.dart';
import 'package:eict_spaces_adm/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../firebase_options.dart';
import 'package:eict_spaces_adm/controllers/utils.dart';

import 'CurrentAppointments.dart';


class Spaces extends StatefulWidget {
  const Spaces({super.key});

  @override
  State<Spaces> createState() => _spacesState();
}

class _spacesState extends State<Spaces> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  mainController controller = Get.find();
  List spaceList = [];

  @override
  Widget build(BuildContext context) {
    var as = MediaQuery.of(context).size.aspectRatio;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyApp(),
                ),
              );
            },
          ),
        ],
        //title: Text(widget.title),
        title: const Text('Spaces'),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: FutureBuilder(
            future: getSpaces(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // print("Filter (main): ${controller.getFilter()}");
                // print("----------------------------------- ${controller.test.value}");
                if (snapshot.hasData) {
                  List? spaces = snapshot.data?.toList();
                  return Center(
                    child: GridView.builder(
                        itemCount: spaces?.length,
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: (2/3)*(as > 0.7 ? 1 : as*1.5),
                        ),
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: spaceList.contains(spaces?[index]['id']) ? 5 : 1,
                                //color: Theme.of(context).colorScheme.outline,
                                color: spaceList.contains(spaces?[index]['id']) ? Colors.green : Theme.of(context).colorScheme.outline,
                              ),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                            ),
                            child: InkWell(
                                customBorder: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                    Theme.of(context).colorScheme.outline,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                onTap: () {
                                  if (spaceList.contains(spaces?[index]['id'])) {
                                    spaceList.remove(spaces?[index]['id']);
                                  } else {
                                    spaceList.add(spaces?[index]['id']);
                                  }
                                  setState(() {});
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ClipRRect(
                                      //width: double.infinity,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      child: Image.network(
                                        'https://picsum.photos/500',
                                        width: double.infinity,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(top: 16),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            spaces?[index]['name'] ??
                                                'Sin nombre',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                              '${spaces?[index]['campus']} - ${spaces?[index]['location']}' ??
                                                  'Sin ubicación',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              textAlign: TextAlign.center
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.people),
                                                Text(
                                                    '${spaces?[index]['student_capacity'] ?? 'Sin capacidad'}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    textAlign: TextAlign.center
                                                ),
                                                const SizedBox(
                                                  width: 24,),
                                                const Icon(Icons.computer),
                                                Text(
                                                    '${spaces?[index]['equipment_amount'] ?? 'Sin equipos'}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    textAlign: TextAlign.center
                                                ),
                                              ]),

                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        }),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      'No data',
                      style: TextStyle(fontSize: 24),
                    ),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // print("Filter (main-> fp): ${controller.getFilter()}");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CurrentApointments()),
          );
        },
        tooltip: 'Calendario',
        child: const Icon(Icons.calendar_today),
      ),
    );
  }
}
