import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final CollectionReference employees =
      FirebaseFirestore.instance.collection('employees');

  // CREATE
  Future<void> addEmployee(Map<String, dynamic> employeeData, String id) {
    return employees.doc(id).set(employeeData);
  }

  // READ
  Stream<QuerySnapshot> getEmployees() {
    return employees.snapshots();
  }

  // UPDATE
  Future<void> updateEmployee(String id, Map<String, dynamic> newValues) {
    return employees.doc(id).update(newValues);
  }

  // DELETE
  Future<void> deleteEmployee(String id) {
    return employees.doc(id).delete();
  }
}