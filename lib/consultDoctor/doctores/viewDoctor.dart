import 'package:consult_doctor/data/dto/dto.dart';
import 'package:consult_doctor/data/service/services.dart';
import 'package:flutter/material.dart';

class ViewDoctor extends StatefulWidget {
  final int idDoctor;
  const ViewDoctor({super.key, required this.idDoctor});

  @override
  State<ViewDoctor> createState() => _ViewDoctorState();
}

class _ViewDoctorState extends State<ViewDoctor> {
  late Future<DoctorDtoOther> _dataDoctor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataDoctor = getOneDoctorData(widget.idDoctor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Doctor', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<DoctorDtoOther>(
              future: _dataDoctor,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(
                                    100), // Asegúrate de que coincida con el borderRadius de ClipRRect
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    100), // Ajusta el radio según sea necesario
                                child: Image.network(
                                  snapshot.data!.photo,
                                  height: 300,
                                  width: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  snapshot.data!.nombre,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data!.especialidad,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ],
                            )
                          ],
                        ),
                        Card(
                          elevation: 10,
                          child: ListTile(
                            title: const Text('Horario de trabajo',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            subtitle: Text(snapshot.data!.horario_trabajo,
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                        Card(
                          elevation: 10,
                          child: ListTile(
                            title: const Text('Teléfono',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            subtitle: Text(snapshot.data!.telefono,
                                style: const TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Text('No data available');
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Llamar'),
                          content: const Text('¿Desea llamar al doctor?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Llamada aceptada. Se le notificará cuando el doctor esté disponible.'),
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                  ),
                  child: const Text('Llamar',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Sacar cita'),
                        content: const Text('¿Desea sacar cita con el doctor?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Cita enviada. Se le notificará cuando sea confirmada.'),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                            child: const Text('Aceptar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                ),
                child: const Text('Sacar cita',
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
