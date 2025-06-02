import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  //EMPLOYEES
  final CollectionReference employees =
      FirebaseFirestore.instance.collection('employees');


  //PURCHASE ORDER
  final CollectionReference PurchaseOrder =
      FirebaseFirestore.instance.collection('purchase_order');

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

  // === CRUD untuk Purchase Orders ===

  //CREATE
  Future<void> addPurchaseOrder(String id, Map<String, dynamic> poData) {
    return PurchaseOrder.doc(id).set(poData);
  }


  //READ
  Stream<QuerySnapshot> getPurchaseOrders() {
    return PurchaseOrder.snapshots();
  }


  //UPDATE
  Future<void> updatePurchaseOrder(String id, Map<String, dynamic> newData) {
    return PurchaseOrder.doc(id).update(newData);
  }


  //DELETE
  Future<void> deletePurchaseOrder(String id) {
    return PurchaseOrder.doc(id).delete();
  }
}
