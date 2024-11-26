import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:consult_doctor/auth/login.dart';
import 'package:consult_doctor/consultDoctor/home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    final provider = await SharedPreferences.getInstance();
    return provider.getString('email') != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'consult doctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error al verificar estado de sesión"));
          }
          return snapshot.data == true ? const MyHomePage() : const LoginPage();
        },
      ),
    );
  }
}