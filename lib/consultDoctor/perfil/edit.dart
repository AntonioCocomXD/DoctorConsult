import 'package:flutter/material.dart';

class EditPregileScreen extends StatefulWidget {
  @override
  _EditPregileScreenState createState() => _EditPregileScreenState();
}

class _EditPregileScreenState extends State<EditPregileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = 'gerardo@gmail.com';
    _phoneController.text = '9995764652';
    _passwordController.text = 'S2b\$10\$GQlAWKzPyh\$06C6otedlukDQKw4FbthVw/8EGzeam6...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pregile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16.0),
              CircleAvatar(
                radius: 50.0,
                backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQJbMBtleQ0FxP8CHkmDkp2Gqi3XBe-w2YYgQ&s'),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save the form data
                  }
                },
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}