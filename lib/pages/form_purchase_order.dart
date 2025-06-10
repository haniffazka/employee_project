// import 'package:flutter/material.dart';
// import 'package:employee_project/models/purchase_order_model.dart';
// import 'package:employee_project/models/purchase_order_detail_model.dart';
// import 'package:employee_project/services/database.dart';

// class FormPoPage extends StatefulWidget {
//   final bool isUpdate;
//   final String? documentId;
//   final PoHeader? currentHeader;
//   final List<PoDetail>? currentItems;

//   const FormPoPage({
//     super.key,
//     this.isUpdate = false,
//     this.documentId,
//     this.currentHeader,
//     this.currentItems,
//   });

//   @override
//   State<FormPoPage> createState() => _FormPoPageState();
// }

// class _FormPoPageState extends State<FormPoPage> {
//   late TextEditingController purchaseOrderNoController;
//   late TextEditingController descriptionController;
//   late TextEditingController supplierCodeController;
//   late List<PoDetail> items = [];

//   @override
//   void initState() {
//     super.initState();

//     if (widget.isUpdate && widget.currentHeader != null) {
//       purchaseOrderNoController = TextEditingController(
//         text: widget.currentHeader!.purchaseOrderNo,
//       );
//       descriptionController = TextEditingController(
//         text: widget.currentHeader!.description,
//       );
//       supplierCodeController = TextEditingController(
//         text: widget.currentHeader!.supplierCode,
//       );

//       if (widget.currentItems != null) {
//         items = widget.currentItems!;
//       }
//     } else {
//       purchaseOrderNoController = TextEditingController();
//       descriptionController = TextEditingController();
//       supplierCodeController = TextEditingController();
//     }
//   }

//   void _addItem() {
//     setState(() {
//       items.add(PoDetail(
//         lineNo: items.length + 1,
//         itemCode: '',
//         item: '',
//         description: '',
//         quantity: 0.0,
//         uom: '',
//         unitPrice: 0.0,
//         amount: 0.0,
//         discount: 0.0,
//         subtotal: 0.0,
//         expiredDate: '',
//       ));
//     });
//   }

//   void _removeItem(int index) {
//     setState(() {
//       items.removeAt(index);
//     });
//   }

//   void _submitForm() async {
//     final header = PoHeader(
//       purchaseOrderNo: purchaseOrderNoController.text.trim(),
//       poType: 'EPT - Taxed', // Default value
//       currency: 'IDR', // Default value
//       supplierCode: supplierCodeController.text.trim(),
//       description: descriptionController.text.trim(),
//       createdBy: 'Admin', // Default value
//       confirmedBy: '', // Default value
//       maxIdentifierNo: '12345', // Default value
//     );

//     if (widget.isUpdate && widget.documentId != null) {
//       await DatabaseMethods().addPurchaseOrder(
//       header.purchaseOrderNo, // atau gunakan ID sesuai kebutuhan
//       header.toMap(),
// );
//     } else {
//       await DatabaseMethods().updatePurchaseOrder(
//       widget.documentId!,
//       header.toMap(),
// );
//     }

//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.isUpdate ? "Edit PO" : "Create New PO"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Header Section
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: purchaseOrderNoController,
//                     decoration: InputDecoration(labelText: "Purchase Order No."),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 DropdownButton<String>(
//                   value: 'IDR',
//                   items: ['IDR', 'USD'].map((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Text(value),
//                     );
//                   }).toList(),
//                   onChanged: (value) {},
//                 ),
//               ],
//             ),
//             SizedBox(height: 16),

//             // Description
//             TextField(
//               controller: descriptionController,
//               decoration: InputDecoration(labelText: "Description"),
//             ),

//             // Supplier Code
//             TextField(
//               controller: supplierCodeController,
//               decoration: InputDecoration(labelText: "Supplier Code"),
//             ),

//             // Items Table
//             DataTable(
//               columns: [
//                 DataColumn(label: Text("Line No.")),
//                 DataColumn(label: Text("Item Code")),
//                 DataColumn(label: Text("Item")),
//                 DataColumn(label: Text("Description")),
//                 DataColumn(label: Text("Qty")),
//                 DataColumn(label: Text("UOM")),
//                 DataColumn(label: Text("Unit Price")),
//                 DataColumn(label: Text("Amount")),
//                 DataColumn(label: Text("Discount")),
//                 DataColumn(label: Text("Subtotal")),
//                 DataColumn(label: Text("Expired Date")),
//               ],
//               rows: items.map((item) {
//                 return DataRow(cells: [
//                   DataCell(Text(item.lineNo.toString())),
//                   DataCell(Text(item.itemCode)),
//                   DataCell(Text(item.item)),
//                   DataCell(Text(item.description)),
//                   DataCell(Text(item.quantity.toString())),
//                   DataCell(Text(item.uom)),
//                   DataCell(Text(item.unitPrice.toString())),
//                   DataCell(Text(item.amount.toString())),
//                   DataCell(Text(item.discount.toString())),
//                   DataCell(Text(item.subtotal.toString())),
//                   DataCell(Text(item.expiredDate)),
//                 ]);
//               }).toList(),
//             ),

//             // Buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: _addItem,
//                   child: Text("+ Add Row"),
//                 ),
//                 SizedBox(width: 8),
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (context) => AlertDialog(
//                         title: Text("Delete Rows"),
//                         content: Text("Are you sure?"),
//                         actions: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: Text("Cancel"),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               // Logic to delete selected rows
//                               Navigator.pop(context);
//                             },
//                             child: Text("Delete"),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                   child: Text("- Delete Rows"),
//                 ),
//               ],
//             ),

//             // Submit Button
//             ElevatedButton(
//               onPressed: _submitForm,
//               child: Text(widget.isUpdate ? "Save" : "Create"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }