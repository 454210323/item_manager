import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterItemForm extends StatefulWidget {
  const RegisterItemForm({super.key});

  @override
  _RegisterItemFormState createState() => _RegisterItemFormState();
}

class _RegisterItemFormState extends State<RegisterItemForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final response = await http.post(
      Uri.parse('https://your-api-url.com/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': _username,
        'password': _password,
      }),
    );

    if (response.statusCode == 200) {
      // Handle success
      print('Registration successful');
    } else {
      // Handle error
      print('Registration failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Form'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Username'),
              onSaved: (value) {
                _username = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
              onSaved: (value) {
                _password = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
