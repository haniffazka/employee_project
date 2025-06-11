import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employee_project/models/purchase_order_model.dart';
import 'package:employee_project/models/purchase_order_detail_model.dart';
import 'package:employee_project/services/database.dart';

class PurchaseOrderPage extends StatefulWidget {
  const PurchaseOrderPage({super.key});

  @override
  State<PurchaseOrderPage> createState() => _PurchaseOrderPageState();
}

class _PurchaseOrderPageState extends State<PurchaseOrderPage> {
  final DatabaseMethods db = DatabaseMethods();

  // Header Controller
  final TextEditingController _poNoController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _createdByController = TextEditingController();

  String _selectedPOType = 'EPT - Taxed';
  String _selectedCurrency = 'IDR';

  List<PoDetail> details = [];
  PoHeader? _editingPo;

  void _addDetailRow() {
    setState(() {
      details.add(
        PoDetail(
          lineNo: details.length + 1,
          itemCode: '',
          item: '',
          description: '',
          quantity: 1,
          uom: 'PCS',
          unitPrice: 0,
          amount: 0,
          discount: 0,
          subtotal: 0,
          expiredDate: '',
        ),
      );
    });
  }

  void _savePO() async {
    final poHeader = PoHeader(
      purchaseOrderNo: _poNoController.text,
      poType: _selectedPOType,
      currency: _selectedCurrency,
      supplierCode: _supplierController.text,
      description: _descController.text,
      createdBy: _createdByController.text,
      confirmedBy: '',
      maxIdentifierNo: '',
    );

    await db.addPurchaseOrder(poHeader);
    for (var detail in details) {
      await db.addPoDetail(poHeader.purchaseOrderNo, detail);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PO Saved")));
    _clearForm();
  }

  void _updatePO() async {
    if (_editingPo == null) return;

    final updatedPo = PoHeader(
      purchaseOrderNo: _poNoController.text,
      poType: _selectedPOType,
      currency: _selectedCurrency,
      supplierCode: _supplierController.text,
      description: _descController.text,
      createdBy: _createdByController.text,
      confirmedBy: '',
      maxIdentifierNo: '',
    );

    await FirebaseFirestore.instance
        .collection('po_headers')
        .doc(updatedPo.purchaseOrderNo)
        .update(updatedPo.toMap());

    final detailRef = FirebaseFirestore.instance
        .collection('po_headers')
        .doc(updatedPo.purchaseOrderNo)
        .collection('details');

    // Delete existing details
    final detailSnapshot = await detailRef.get();
    for (var doc in detailSnapshot.docs) {
      await doc.reference.delete();
    }

    // Add new details
    for (var detail in details) {
      await detailRef.add(detail.toMap());
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PO Updated")));
    _clearForm();
  }

  void _clearForm() {
    setState(() {
      _editingPo = null;
      _poNoController.clear();
      _supplierController.clear();
      _descController.clear();
      _createdByController.clear();
      details.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Purchase Order")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("PO Header", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: _poNoController, decoration: InputDecoration(labelText: 'PO Number')),
            DropdownButton<String>(
  value: ['EPT - Taxed', 'EPT - Non Taxed'].contains(_selectedPOType)
      ? _selectedPOType
      : null,
  onChanged: (value) => setState(() => _selectedPOType = value!),
  items: ['EPT - Taxed', 'EPT - Non Taxed']
      .map((type) => DropdownMenuItem(value: type, child: Text(type)))
      .toList(),
  hint: Text("Select PO Type"),
),

            DropdownButton<String>(
  value: ['IDR', 'USD'].contains(_selectedCurrency) ? _selectedCurrency : null,
  onChanged: (value) => setState(() => _selectedCurrency = value!),
  items: ['IDR', 'USD']
      .map((curr) => DropdownMenuItem(value: curr, child: Text(curr)))
      .toList(),
  hint: Text("Select Currency"),
),

            TextField(controller: _supplierController, decoration: InputDecoration(labelText: 'Supplier Code')),
            TextField(controller: _descController, decoration: InputDecoration(labelText: 'Description')),
            TextField(controller: _createdByController, decoration: InputDecoration(labelText: 'Created By')),

            const SizedBox(height: 20),
            const Text("PO Detail", style: TextStyle(fontWeight: FontWeight.bold)),
            ...details.map((detail) {
              int index = details.indexOf(detail);
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Item Code'),
                      onChanged: (val) => details[index].itemCode = val,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Item Name'),
                      onChanged: (val) => details[index].item = val,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Qty'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => details[index].quantity = double.tryParse(val) ?? 0,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Unit Price'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) => details[index].unitPrice = double.tryParse(val) ?? 0,
                    ),
                  ]),
                ),
              );
            }),

            ElevatedButton.icon(
              onPressed: _addDetailRow,
              icon: Icon(Icons.add),
              label: const Text("Add Detail Row"),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_editingPo != null) {
                  _updatePO();
                } else {
                  _savePO();
                }
              },
              child: Text(_editingPo != null ? "Update PO" : "Create PO"),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const Text("List Purchase Orders", style: TextStyle(fontWeight: FontWeight.bold)),

            StreamBuilder<QuerySnapshot>(
              stream: db.getPurchaseOrders(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final po = PoHeader.fromMap(docs[index].data() as Map<String, dynamic>);
                    return Card(
                      child: ListTile(
                        title: Text(po.purchaseOrderNo),
                        subtitle: Text("${po.supplierCode} - ${po.description}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                setState(() {
                                  _editingPo = po;
                                  _poNoController.text = po.purchaseOrderNo;
                                  _selectedPOType = po.poType;
                                  _selectedCurrency = po.currency;
                                  _supplierController.text = po.supplierCode;
                                  _descController.text = po.description;
                                  _createdByController.text = po.createdBy;
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('po_headers')
                                    .doc(po.purchaseOrderNo)
                                    .delete();

                                final detailSnapshot = await FirebaseFirestore.instance
                                    .collection('po_headers')
                                    .doc(po.purchaseOrderNo)
                                    .collection('details')
                                    .get();

                                for (var doc in detailSnapshot.docs) {
                                  await doc.reference.delete();
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("PO ${po.purchaseOrderNo} deleted")),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
