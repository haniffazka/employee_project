import 'package:employee_project/services/database.dart';
import 'package:flutter/material.dart';
import 'package:employee_project/pages/form_employee.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Stream<QuerySnapshot> employeeStream;

  @override
  void initState() {
    super.initState();
    employeeStream = DatabaseMethods().getEmployees();
  }

  void _showEditDialog(BuildContext context, DocumentSnapshot document) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormEmployeePage(
          isUpdate: true,
          currentData: document.data() as Map<String, dynamic>,
          documentId: document.id,
        ),
      ),
    ).then((value) {
      if (value == true) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Karyawan")),
      body: StreamBuilder<QuerySnapshot>(
        stream: employeeStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final List<DocumentSnapshot> docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot doc = docs[index];
              return ListTile(
                title: Text("${doc['name']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Usia: ${doc['age']}"),
                    Text("Lokasi: ${doc['location']}"),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showEditDialog(context, doc),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          DatabaseMethods().deleteEmployee(doc.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormEmployeePage()),
          ).then((value) {
            if (value == true) {
              setState(() {});
            }
          });
        },
      ),
    );
  }
}