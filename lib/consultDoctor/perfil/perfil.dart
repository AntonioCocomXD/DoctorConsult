import 'package:consult_doctor/consultDoctor/perfil/edit.dart';
import 'package:consult_doctor/data/dto/dto.dart';
import 'package:consult_doctor/data/service/services.dart';
import 'package:flutter/material.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  late Future<List<UserDto>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<UserDto>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No se encontraron datos del usuario'));
          }

          final user = snapshot.data!.first;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildProfileHeader(user),
                  const SizedBox(height: 24),
                  _buildUserInfo(user),
                  const SizedBox(height: 32),
                  _buildEditProfileButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(UserDto user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: const NetworkImage(
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJbMBtleQ0FxP8CHkmDkp2Gqi3XBe-w2YYgQ&s',
          ),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.blue, width: 3),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.nombre,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'ID: ${user.id}',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildUserInfo(UserDto user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow(
                Icons.email, 'Correo electrónico', user.correo_electronico),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, 'Teléfono', user.telefono),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return ElevatedButton.icon( 
      onPressed: () {
        Navigator.push(context, 
          MaterialPageRoute(builder: (context) => EditPregileScreen())
        );
      },
      icon: const Icon(Icons.edit, color: Colors.blue,),
      label: const Text('Editar Perfil', style: TextStyle(color: Colors.blue),),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
