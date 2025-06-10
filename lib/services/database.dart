// services/database.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_project/models/purchase_order_model.dart';
import 'package:employee_project/models/purchase_order_detail_model.dart';
class DatabaseMethods {
  // Collection References
  final CollectionReference employees =
      FirebaseFirestore.instance.collection('employees');

  final CollectionReference purchaseOrders =
      FirebaseFirestore.instance.collection('purchase_orders');

  // === EMPLOYEE CRUD ===

  Future<void> addEmployee(Map<String, dynamic> employeeData, String id) {
    return employees.doc(id).set(employeeData);
  }

  Stream<QuerySnapshot> getEmployees() {
    return employees.snapshots();
  }

  Future<void> updateEmployee(String id, Map<String, dynamic> newValues) {
    return employees.doc(id).update(newValues);
  }

  Future<void> deleteEmployee(String id) {
    return employees.doc(id).delete();
  }

  // === PURCHASE ORDER HEADER CRUD ===

  /// Menyimpan PO Header
  Future<void> addPurchaseOrder(PoHeader poHeader) {
    return purchaseOrders.doc(poHeader.purchaseOrderNo).set(poHeader.toMap());
  }

  /// Mendapatkan semua PO Header
  Stream<QuerySnapshot> getPurchaseOrders() {
    return purchaseOrders.snapshots();
  }

  /// Mengupdate PO Header
  Future<void> updatePurchaseOrder(String poId, Map<String, dynamic> newData) {
    return purchaseOrders.doc(poId).update(newData);
  }

  /// Menghapus PO Header
  Future<void> deletePurchaseOrder(String poId) {
    return purchaseOrders.doc(poId).delete();
  }

  // === PURCHASE ORDER DETAIL CRUD (subcollection) ===

  /// Menambah detail PO sebagai subcollection
  Future<void> addPoDetail(String poId, PoDetail poDetail) async {
    final DocumentReference poDocRef = purchaseOrders.doc(poId);
    final CollectionReference detailsRef = poDocRef.collection('details');
    await detailsRef.add(poDetail.toMap());
  }

  /// Mendapatkan detail PO berdasarkan ID PO
  Stream<QuerySnapshot> getPoDetails(String poId) {
    return purchaseOrders.doc(poId).collection('details').snapshots();
  }

  /// Mengupdate detail PO
  Future<void> updatePoDetail(String poId, String detailId, Map<String, dynamic> newData) {
    return purchaseOrders.doc(poId).collection('details').doc(detailId).update(newData);
  }

  /// Menghapus detail PO
  Future<void> deletePoDetail(String poId, String detailId) {
    return purchaseOrders.doc(poId).collection('details').doc(detailId).delete();
  }
}