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
      Uri.parse("http://192.168.1.78:3000/consultDoctor/api/doctores/$id"),
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
    Uri.parse("http://192.168.1.78:3000/consultDoctor/api/citas"),
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

class _CitasState extends State<Citas> {
  late final Future<List<CitasDto>> citasFuture;

  @override
  void initState() {
    super.initState();
    citasFuture = getOneCitas();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CitasDto>>(
      future: citasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error al cargar las citas',
              style: TextStyle(color: Colors.red[700], fontSize: 18),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No tienes citas agendadas',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
          );
        } else {
          final citas = snapshot.data!;
          return ListView.builder(
            itemCount: citas.length,
            itemBuilder: (context, index) {
              final cita = citas[index];
              return _buildCitaCard(cita);
            },
          );
        }
      },
    );
  }

  Widget _buildCitaCard(CitasDto cita) {
    final theme = Theme.of(context);
    final dateTime = DateTime.parse(cita.fecha_hora);
    final formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    final formattedTime = DateFormat('HH:mm').format(dateTime);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.medical_services, color: theme.primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cita.doctor,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(Icons.event, 'Fecha:', formattedDate),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.access_time, 'Hora:', formattedTime),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.info_outline, 'Asunto:', cita.asunto),
            const SizedBox(height: 16),
            _buildStatusChip(cita.estado),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87))),
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
