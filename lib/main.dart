import 'package:consult_doctor/auth/login.dart';
import 'package:consult_doctor/consultDoctor/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLogged = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final provider = await SharedPreferences.getInstance();
    if (provider.getString('email') != null) {
      setState(() {
        _isLogged = true;
      });
    } else {
      setState(() {
        _isLogged = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'consult doctor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isLogged ? const MyHomePage() : const LoginPage(),
    );
  }
}
