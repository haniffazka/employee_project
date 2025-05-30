import 'package:employee_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FormEmployeePage extends StatefulWidget {
  final bool isUpdate;
  final Map<String, dynamic>? currentData;
  final String? documentId;

  const FormEmployeePage({
    super.key,
    this.isUpdate = false,
    this.currentData,
    this.documentId,
  });

  @override
  State<FormEmployeePage> createState() => _FormEmployeePageState();
}

class _FormEmployeePageState extends State<FormEmployeePage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController locationController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
        text: widget.currentData?['name'] ?? '');
    ageController = TextEditingController(
        text: widget.currentData?['age']?.toString() ?? '');
    locationController = TextEditingController(
        text: widget.currentData?['location'] ?? '');
  }

  void _submitForm() async {
    String name = nameController.text.trim();
    String age = ageController.text.trim();
    String location = locationController.text.trim();

    if (name.isEmpty || age.isEmpty || location.isEmpty) {
      Fluttertoast.showToast(msg: "Semua field harus diisi");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> data = {
      'name': name,
      'age': int.tryParse(age) ?? 0,
      'location': location,
    };

    if (widget.isUpdate && widget.documentId != null) {
      await DatabaseMethods()
          .updateEmployee(widget.documentId!, data)
          .then((_) {
        Fluttertoast.showToast(msg: "Data berhasil diubah");
        Navigator.pop(context, true);
      }).catchError((e) {
        Fluttertoast.showToast(msg: "Gagal mengubah data: $e");
      });
    } else {
      String id = randomAlphaNumeric(10);
      await DatabaseMethods().addEmployee(data, id).then((_) {
        Fluttertoast.showToast(msg: "Data berhasil ditambahkan");
        Navigator.pop(context, true);
      }).catchError((e) {
        Fluttertoast.showToast(msg: "Gagal menambahkan data: $e");
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isUpdate ? "Edit Karyawan" : "Tambah Karyawan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Usia"),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: "Lokasi"),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(widget.isUpdate ? "Simpan" : "Tambah"),
                  )
          ],
        ),
      ),
    );
  }
}