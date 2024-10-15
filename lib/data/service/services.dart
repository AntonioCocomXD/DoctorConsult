import 'package:consult_doctor/data/dto/dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<DoctorDto>> getDoctorData() async {
  final response = await http.get(
    Uri.parse("http://localhost:3000/consultDoctor/api/doctores"),
    headers: {'Content-Type': 'application/json'},
  );
  final List<DoctorDto> doctores = [];

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body) as List;

    for (var item in jsonData) {
      doctores.add(DoctorDto(
        id: item['id'],
        nombre: item['nombre'],
        especialidad: item['especialidad'],
        horario_trabajo: item['horario_trabajo'],
        telefono: item['telefono'],
        photo: item['foto'],
      ));
    }
    return doctores;
  } else {
    throw Exception('Error al recuperar los elementos del carrito');
  }
}
