import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorAppointmentForm extends StatefulWidget {
  final Doctor doctor;

  const DoctorAppointmentForm({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorAppointmentFormState createState() => _DoctorAppointmentFormState();
}

class Doctor {
  final String name;
  final String specialty;
  final String imageUrl;
  final List<String> availableDays;

  Doctor({
    required this.name, 
    required this.specialty, 
    required this.imageUrl,
    required this.availableDays
  });
}

class _DoctorAppointmentFormState extends State<DoctorAppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _motivoController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<String> _availableTimes = [
    '09:00', '10:00', '11:00', 
    '14:00', '15:00', '16:00', 
    '17:00'
  ];

  void _selectDate(BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 30)),
    selectableDayPredicate: (DateTime date) {
      final String dayOfWeek = DateFormat('EEEE', 'es')
          .format(date)
          .toLowerCase();
      return widget.doctor.availableDays
          .map((day) => day.toLowerCase())
          .contains(dayOfWeek);
    },
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light(
            primary: Colors.blue[700]!,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    setState(() {
      _selectedDate = picked;
      _selectedTime = null; // Limpiar la hora seleccionada al cambiar la fecha
    });
  }
}


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cita Confirmada', style: TextStyle(color: Colors.white),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detalles de la Cita:'),
              Text('Doctor: ${widget.doctor.name}'),
              Text('Fecha: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
              Text('Hora: ${_selectedTime!.format(context)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Aceptar'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservar Cita', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue[700],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.blue[50],
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.doctor.imageUrl),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.doctor.specialty,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre Completo',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) => 
                        value!.isEmpty ? 'Ingrese su nombre' : null,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo Electrónico',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) return 'Ingrese su correo';
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value) 
                          ? null 
                          : 'Correo inválido';
                      },
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _telefonoController,
                      decoration: InputDecoration(
                        labelText: 'Número de Teléfono',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => 
                        value!.isEmpty ? 'Ingrese su teléfono' : null,
                    ),
                    SizedBox(height: 16),

                    TextFormField(
                      controller: _motivoController,
                      decoration: InputDecoration(
                        labelText: 'Motivo de la Consulta',
                        prefixIcon: Icon(Icons.medical_services),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) => 
                        value!.isEmpty ? 'Describa el motivo de su consulta' : null,
                    ),
                    SizedBox(height: 16),

                    ElevatedButton.icon(
                      icon: Icon(Icons.calendar_today,color: Colors.white),
                      label: Text(_selectedDate == null 
                        ? 'Seleccionar Fecha' 
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!), style: TextStyle(color: Colors.white),),
                      onPressed: () => _selectDate(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                    SizedBox(height: 16),
                    if (_selectedDate != null)
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Hora de la Cita',
                          prefixIcon: Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        hint: Text('Seleccione una hora'),
                        items: _availableTimes.map((time) {
                          return DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTime = TimeOfDay(
                              hour: int.parse(value!.split(':')[0]),
                              minute: int.parse(value.split(':')[1]),
                            );
                          });
                        },
                        validator: (value) => 
                          value == null ? 'Seleccione una hora' : null,
                      ),
                    SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Reservar Cita', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}