import 'package:flutter/material.dart';

class Config extends StatefulWidget {
  const Config({super.key});

  @override
  State<Config> createState() => _ConfigState();
}

class _ConfigState extends State<Config> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  double _fontSize = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white)
      ),
      body: ListView(
        children: [
          _buildSectionHeader('General'),
          SwitchListTile(
            title: const Text('Notificaciones'),
            subtitle: const Text('Activar o desactivar notificaciones'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Modo oscuro'),
            subtitle: const Text('Cambiar entre tema claro y oscuro'),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          _buildSectionHeader('Apariencia'),
          ListTile(
            title: const Text('Tamaño de fuente'),
            subtitle: Text('Actual: ${_fontSize.round()}'),
            trailing: SizedBox(
              width: 200,
              child: Slider(
                value: _fontSize,
                min: 12,
                max: 24,
                divisions: 12,
                label: _fontSize.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
              ),
            ),
          ),
          _buildSectionHeader('Cuenta'),
          ListTile(
            title: const Text('Cambiar contraseña'),
            leading: const Icon(Icons.lock_outline),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Privacidad'),
            leading: const Icon(Icons.privacy_tip_outlined),
            onTap: () {},
          ),
          _buildSectionHeader('Información'),
          ListTile(
            title: const Text('Acerca de'),
            leading: const Icon(Icons.info_outline),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Términos y condiciones'),
            leading: const Icon(Icons.description_outlined),
            onTap: () {},
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar sesión'),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue[800],
        ),
      ),
    );
  }
}
