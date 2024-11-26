import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitasDto {
  final int id;
  final int usuario;
  final String doctor;
  final String fecha_hora;
  final String estado;
  final String asunto;

  CitasDto(
      {required this.id,
      required this.usuario,
      required this.doctor,
      required this.fecha_hora,
      required this.estado,
      required this.asunto});
}

class DoctorDto {
  final int id;
  final String nombre;
  final String especialidad;

  DoctorDto({
    required this.id,
    required this.nombre,
    required this.especialidad,
  });
  static Future<DoctorDto> getDoctorForId(int id) async {
    final response = await http.get(
      Uri.parse("http://192.168.1.75:3000/consultDoctor/api/doctores/$id"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      return DoctorDto(
        id: jsonData['id'],
        nombre: jsonData['nombre'],
        especialidad: jsonData['especialidad'],
      );
    } else {
      throw Exception('Error al recuperar los datos del doctor');
    }
  }
}

Future<List<CitasDto>> getOneCitas() async {
  final provider = await SharedPreferences.getInstance();
  final response = await http.get(
    Uri.parse("http://192.168.1.75:3000/consultDoctor/api/citas"),
    headers: {'Content-Type': 'application/json'},
  );
  final List<CitasDto> citas = [];

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body) as List;
    final id = provider.getInt('id');
    for (var item in jsonData) {
      if (item['usuario_id'] == id) {
        final doctor = await DoctorDto.getDoctorForId(item['doctor_id']);
        citas.add(CitasDto(
            id: item['id'],
            usuario: item['usuario_id'],
            doctor: doctor.nombre,
            fecha_hora: item['fecha_hora'].toString(),
            estado: item['estado'],
            asunto: item['asunto']));
      }
    }
    return citas;
  } else {
    throw Exception('Error al recuperar las citas');
  }
}

class Citas extends StatefulWidget {
  const Citas({super.key});

  @override
  State<Citas> createState() => _CitasState();
}

class _CitasState extends State<Citas> with SingleTickerProviderStateMixin {
  late final Future<List<CitasDto>> citasFuture;
  late TabController _tabController;
  List<CitasDto> _allCitas = [];
  List<CitasDto> _filteredCitas = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    citasFuture = getOneCitas().then((citas) {
      setState(() {
        _allCitas = citas;
        _filteredCitas = citas;
      });
      return citas;
    });

    _tabController.addListener(() {
      _filterCitasByStatus(_tabController.index);
    });
  }

  void _filterCitasByStatus(int index) {
    setState(() {
      switch (index) {
        case 0:
          _filteredCitas = _allCitas;
          break;
        case 1:
          _filteredCitas = _allCitas
              .where((cita) => cita.estado.toLowerCase() == 'confirmada')
              .toList();
          break;
        case 2:
          _filteredCitas = _allCitas
              .where((cita) => cita.estado.toLowerCase() == 'pendiente')
              .toList();
          break;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lista", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade300,
          tabs: const [
            Tab(text: 'Todas'),
            Tab(text: 'Confirmadas'),
            Tab(text: 'Pendientes'),
          ],
        ),
      ),
      body: FutureBuilder<List<CitasDto>>(
        future: citasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.blue.shade600,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: Colors.red.shade300, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar las citas',
                    style: TextStyle(color: Colors.red.shade600, fontSize: 18),
                  ),
                ],
              ),
            );
          } else if (_filteredCitas.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today,
                      color: Colors.blue.shade200, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes citas agendadas',
                    style: TextStyle(color: Colors.blue.shade600, fontSize: 18),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _filteredCitas.length,
              itemBuilder: (context, index) {
                final cita = _filteredCitas[index];
                return _buildCitaCard(cita);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildCitaCard(CitasDto cita) {
    final dateTime = DateTime.parse(cita.fecha_hora);
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.blue.shade50,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            // Optional: Add interaction or navigation
            _showCitaDetailsBottomSheet(cita, formattedDate, formattedTime);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_services_outlined,
                        color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        cita.doctor,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    _buildStatusChip(cita.estado),
                  ],
                ),
                const Divider(height: 24),
                _buildInfoRow(Icons.event_outlined, 'Fecha:', formattedDate),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.access_time_outlined, 'Hora:', formattedTime),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.info_outline_rounded, 'Asunto:', cita.asunto),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCitaDetailsBottomSheet(
      CitasDto cita, String formattedDate, String formattedTime) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Detalles de la Cita',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Doctor', cita.doctor),
            _buildDetailRow('Fecha', formattedDate),
            _buildDetailRow('Hora', formattedTime),
            _buildDetailRow('Asunto', cita.asunto),
            _buildDetailRow('Estado', cita.estado),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.blue.shade700),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade600),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w500, color: Colors.blue.shade700)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String estado) {
    Color chipColor;
    IconData statusIcon;

    switch (estado.toLowerCase()) {
      case 'confirmada':
        chipColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'pendiente':
        chipColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'cancelada':
        chipColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        chipColor = Colors.grey;
        statusIcon = Icons.help_outline;
    }

    return Chip(
      avatar: Icon(statusIcon, color: Colors.white, size: 18),
      label: Text(
        estado,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: chipColor,
    );
  }
}
