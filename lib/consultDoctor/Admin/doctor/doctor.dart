import 'package:consult_doctor/consultDoctor/doctores/viewDoctor.dart';
import 'package:consult_doctor/data/dto/dto.dart';
import 'package:consult_doctor/data/service/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class DoctorAdmin extends StatefulWidget {
  const DoctorAdmin({super.key});

  @override
  State<DoctorAdmin> createState() => _DoctorAdminState();
}

class _DoctorAdminState extends State<DoctorAdmin> {
  late Future<List<DoctorDtoOther>> _dataDoctor;

  @override
  void initState() {
    super.initState();
    _dataDoctor = getDoctorData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctores', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<DoctorDtoOther>>(
        future: _dataDoctor,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay doctores disponibles.'));
          } else {
            List<DoctorDtoOther> doctors = snapshot.data!;
            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                return _buildDoctorCard(doctors[index], context);
              },
            );
          }
        },
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 28.0),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        visible: true,
        curve: Curves.easeInOut,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.request_page, color: Colors.white),
            labelWidget: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Solicitudes',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white, // Texto blanco
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            labelStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.white, // Texto blanco
              fontWeight: FontWeight.bold,
            ),
            labelBackgroundColor: Colors.redAccent, // Fondo para el label
            backgroundColor: Colors.redAccent,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Solicitudes seleccionadas'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(Icons.add, color: Colors.white),
            label: 'Agregar',
            labelStyle: const TextStyle(
              fontSize: 16.0,
              color: Colors.white, // Texto blanco
              fontWeight: FontWeight.bold,
            ),
            labelBackgroundColor: Colors.greenAccent, // Fondo para el label
            backgroundColor: Colors.greenAccent,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Agregar seleccionado'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(DoctorDtoOther doctor, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDoctor(idDoctor: doctor.id),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(doctor.photo),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.nombre,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    doctor.especialidad,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    doctor.telefono,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Editar'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Dar de baja'),
                    ),
                  ])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
