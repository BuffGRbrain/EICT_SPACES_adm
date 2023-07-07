import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'controller.dart';

mainController controller = Get.find();

Future<List> processFilter(collection) async {
  var filter = controller.getFilter();
  // print("FIlter from process: $filter");

  if (!filter['active']) {
    QuerySnapshot querySnapshot = await collection.get();
    List<QueryDocumentSnapshot> spaces = querySnapshot.docs;
    return spaces;
  }

  Map list = filter['list'];
  Map numeric = filter['numeric'];
  list.removeWhere((key, value) => value == '');
  numeric.removeWhere((key, value) => value == -1);
  QuerySnapshot querySnapshot = await collection.get();
  List<QueryDocumentSnapshot> spaces = querySnapshot.docs;

  if (numeric.isNotEmpty){
    // print("Numeric: ${numeric['capacity']}");
    // collection = collection.where('student_capacity', isGreaterThan: numeric['capacity']);
    numeric.forEach((key, value) {
      // collection = collection.where(key, isGreaterThan: value);
      spaces.removeWhere((space) => space[key] < value);
    });
  }


  if (list.isNotEmpty){
    // spaces.removeWhere((space) => !list.values.every((value) => space['categories'].contains(value)));
    // spaces.removeWhere((space) => !space['categories'].contains(list['categories']));
    list.forEach((key, value) {
      spaces.removeWhere((space) => !space[key].contains(value));
    });
  }

  return spaces;

}

Future<List> getSpaces() async {
  // print("Filter (getSpaces): ${controller.getFilter()}");
  var db = FirebaseFirestore.instance;
  List spaces = await processFilter(db.collection('spaces'));
  // spacesCollection = spacesCollection.
  // print(controller.getFilter());


  // spaces.removeWhere((space) => !space['categories'].contains('dio'));
  return spaces.map((e) => ({
    'id': e.id,
    'name': e['name'],
    'amount': e['amount'],
    'area': e['area'],
    'campus': e['campus'],
    'categories': e['categories'],
    'dependency': e['dependency'],
    'equipment_amount': e['equipment_amount'],
    'location': e['location'],
    'services': e['services'],
    'student_capacity': e['student_capacity'],
  })).toList();
}