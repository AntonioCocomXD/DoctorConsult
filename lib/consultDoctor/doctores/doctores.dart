import 'package:flutter/material.dart';
import 'package:consult_doctor/consultDoctor/doctores/viewDoctor.dart';
import 'package:consult_doctor/data/dto/dto.dart';
import 'package:consult_doctor/data/service/services.dart';

class Doctor extends StatefulWidget {
  const Doctor({Key? key}) : super(key: key);

  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends State<Doctor> {
  late Future<List<DoctorDtoOther>> _dataDoctor;
  final TextEditingController _searchController = TextEditingController();
  List<DoctorDtoOther> _doctors = [];
  List<DoctorDtoOther> _filteredDoctors = [];
  String _selectedFilter = "Todos";

  final List<String> _filterOptions = ["Todos", "Nombre", "Especialidad"];

  @override
  void initState() {
    super.initState();
    _dataDoctor = getDoctorData().then((doctors) {
      setState(() {
        _doctors = doctors;
        _filteredDoctors = doctors;
      });
      return doctors;
    });
  }

  void _filterDoctors(String query) {
    List<DoctorDtoOther> tempList;
    switch (_selectedFilter) {
      case "Nombre":
        tempList = _doctors.where((doctor) {
          return doctor.nombre.toLowerCase().contains(query.toLowerCase());
        }).toList();
        break;
      case "Especialidad":
        tempList = _doctors.where((doctor) {
          return doctor.especialidad.toLowerCase().contains(query.toLowerCase());
        }).toList();
        break;
      default:
        tempList = _doctors.where((doctor) {
          return doctor.nombre.toLowerCase().contains(query.toLowerCase()) ||
              doctor.especialidad.toLowerCase().contains(query.toLowerCase());
        }).toList();
    }
    setState(() {
      _filteredDoctors = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterDoctors,
                    decoration: InputDecoration(
                      hintText: 'Buscar doctores',
                      prefixIcon: Icon(Icons.search, color: Colors.blue.shade600),
                      filled: true,
                      fillColor: Colors.blue.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: _filterOptions.map((filter) {
                    return DropdownMenuItem(
                      value: filter,
                      child: Text(filter),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                      _filterDoctors(_searchController.text);
                    });
                  },
                  underline: const SizedBox(),
                  dropdownColor: Colors.white,
                  style: TextStyle(
                    color: Colors.blue.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<DoctorDtoOther>>(
              future: _dataDoctor,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue.shade600,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (_filteredDoctors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          size: 80,
                          color: Colors.blue.shade200,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay doctores disponibles',
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      return _buildDoctorCard(_filteredDoctors[index], context);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(DoctorDtoOther doctor, BuildContext context) {
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewDoctor(idDoctor: doctor.id),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildDoctorAvatar(doctor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.nombre,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildInfoRow(
                        Icons.medical_services_outlined,
                        doctor.especialidad,
                        Colors.blue.shade600,
                      ),
                      _buildInfoRow(
                        Icons.access_time_outlined,
                        doctor.horario_trabajo,
                        Colors.blue.shade600,
                      ),
                      _buildInfoRow(
                        Icons.phone_outlined,
                        doctor.telefono,
                        Colors.blue.shade600,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.blue.shade600,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar(DoctorDtoOther doctor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue.shade100,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade50,
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.blue.shade50,
        backgroundImage: doctor.photo.isNotEmpty ? NetworkImage(doctor.photo) : null,
        child: doctor.photo.isEmpty
            ? Icon(Icons.person, size: 40, color: Colors.blue.shade300)
            : null,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
