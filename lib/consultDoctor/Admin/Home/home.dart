import 'package:consult_doctor/consultDoctor/Admin/doctor/doctor.dart';
import 'package:flutter/material.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Opciones de Admin', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              color: Colors.grey[100],
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DoctorAdmin(),
                    ),
                  );
                },
                child: const ListTile(
                  title: Text('Doctores'),
                  leading: Icon(Icons.medical_services),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              color: Colors.grey[100],
              child: InkWell(
                onTap: () {
                },
                child: const ListTile(
                  title: Text('Citas'),
                  leading: Icon(Icons.calendar_today),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              color: Colors.grey[100],
              child: InkWell(
                onTap: () {
                },
                child: const ListTile(
                  title: Text('Usuarios'),
                  leading: Icon(Icons.person),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              color: Colors.grey[100],
              child: InkWell(
                onTap: () {
                },
                child: const ListTile(
                  title: Text('Estadisticas'),
                  leading: Icon(Icons.bar_chart),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}