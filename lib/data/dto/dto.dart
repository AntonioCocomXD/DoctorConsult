// ignore_for_file: non_constant_identifier_names

class DoctorDto {
  final int id;
  final String nombre;
  final String especialidad;
  final String horario_trabajo;
  final String telefono;
  final String photo;

  DoctorDto({
    required this.id,
    required this.especialidad,
    required this.horario_trabajo,
    required this.nombre,
    required this.telefono,
    required this.photo
  });
}