import 'package:flutter/material.dart';

class AcercaDe extends StatefulWidget {
  const AcercaDe({super.key});

  @override
  State<AcercaDe> createState() => _AcercaDeState();
}

class _AcercaDeState extends State<AcercaDe> {
  final String appVersion = "1.0.0";
  final String appName = "Mi Aplicación";
  final String companyName = "Mi Compañía";
  final String websiteUrl = "www.micompania.com";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
                child:
                    Icon(Icons.medical_services, size: 80, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Versión $appVersion',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 30),
              _buildInfoCard(
                icon: Icons.business,
                title: 'Desarrollado por',
                content: companyName,
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                icon: Icons.web,
                title: 'Sitio web',
                content: websiteUrl,
              ),
              const SizedBox(height: 30),
              const Text(
                'Esta aplicación está diseñada para ayudar a los usuarios a gestionar sus citas médicas de manera eficiente y sencilla.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Términos y Condiciones', style: TextStyle(color: Colors.blue)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      required String content}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 30),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(content,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
