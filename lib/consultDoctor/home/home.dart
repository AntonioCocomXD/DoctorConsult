import 'package:consult_doctor/auth/login.dart';
import 'package:consult_doctor/consultDoctor/citas/citas.dart';
import 'package:consult_doctor/consultDoctor/doctores/doctores.dart';
import 'package:consult_doctor/consultDoctor/perfil/perfil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String ubicacion = 'Doctores';

  // Manejador de cambio de índice en el BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        ubicacion = 'Doctores';
      } else if (index == 1) {
        ubicacion = 'Citas';
      } else {
        ubicacion = 'Perfil';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ubicacion, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.settings),
                        SizedBox(width: 10),
                        Text('Configuración'),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.info),
                        SizedBox(width: 10),
                        Text('Acerca de'),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(Icons.contact_mail),
                        SizedBox(width: 10),
                        Text('Contacto'),
                      ],
                    ),
                  ),
                ),
                PopupMenuItem(
                  child: TextButton(
                    onPressed: () async {
                      final provider = await SharedPreferences.getInstance();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                      provider.remove('email');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 10),
                        Text('Cerrar sesión'),
                      ],
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: _selectedIndex == 0
            ? const Doctor()
            : _selectedIndex == 1
                ? const Citas()
                : const Perfil(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital),
            label: 'Doctores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Citas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
