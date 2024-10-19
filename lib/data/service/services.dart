import 'package:consult_doctor/data/dto/dto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<List<DoctorDtoOther>> getDoctorData() async {
  final response = await http.get(
    Uri.parse("http://localhost:3000/consultDoctor/api/doctores"),
    headers: {'Content-Type': 'application/json'},
  );
  final List<DoctorDtoOther> doctores = [];

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body) as List;

    for (var item in jsonData) {
      doctores.add(DoctorDtoOther(
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

Future<List<UserDto>> getUserData() async {
  final provider = await SharedPreferences.getInstance();
  final response = await http.get(
    Uri.parse("http://localhost:3000/consultDoctor/api/usuarios"),
    headers: {'Content-Type': 'application/json'},
  );
  final List<UserDto> usuarios = [];
  final email = provider.getString('email');

  if (response.statusCode == 200) {
    String body = utf8.decode(response.bodyBytes);
    final jsonData = jsonDecode(body) as List;

    for (var item in jsonData) {
      if (item['correo_electronico'] != email) continue;
      usuarios.add(UserDto(
        id: item['id'],
        nombre: item['nombre'],
        correo_electronico: item['correo_electronico'],
        telefono: item['telefono'],
        constrana: item['contrasena'],
      ));
      provider.setInt('id', item['id']);
    }
    return usuarios;
  } else {
    throw Exception('Error al recuperar los elementos del carrito');
  }
}


