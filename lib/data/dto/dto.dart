// ignore_for_file: non_constant_identifier_names

class DoctorDtoOther {
  final int id;
  final String nombre;
  final String especialidad;
  final String horario_trabajo;
  final String telefono;
  final String photo;

  DoctorDtoOther({
    required this.id,
    required this.especialidad,
    required this.horario_trabajo,
    required this.nombre,
    required this.telefono,
    required this.photo
  });
}

class CitasDto {
  final int id;
  final int usuario;
  final String doctor;
  final String fecha_hora;
  final String estado;
  final String asunto;

  CitasDto({
    required this.id,
    required this.usuario,
    required this.doctor,
    required this.fecha_hora,
    required this.estado,
    required this.asunto
  });
}
class UserDto {
  final int id;
  final String nombre;
  final String correo_electronico;
  final String telefono;
  final String constrana;

  UserDto({
    required this.id,
    required this.nombre,
    required this.correo_electronico,
    required this.telefono,
    required this.constrana
  });
}