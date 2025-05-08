import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ink_review/model/global_vars.dart';
import 'package:xml/xml.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? authToken;

  Future<void> registerUser() async {
    if (nameController.text.isEmpty || 
        surnameController.text.isEmpty || 
        usernameController.text.isEmpty) {
      showError("All fields are required");
      return;
    }

    final url = Uri.parse('http://localhost/web_service/ink_review/register');

    var body;
    if (globalContentType == 'application/json') {
      body = json.encode({
        'username': usernameController.text,
        'nome': nameController.text,
        'cognome': surnameController.text,
      });
    } else if (globalContentType == 'application/xml') {
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0" encoding="UTF-8"');
      builder.element('request', nest: () {
        builder.element('username', nest: usernameController.text);
        builder.element('nome', nest: nameController.text);
        builder.element('cognome', nest: surnameController.text);
      });
      final document = builder.buildDocument();
      body = document.toXmlString(pretty: true);
    }

    try {
      
      final response = await http.post(
        url,
        headers: {'Content-Type': globalContentType,},
        body: body,
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'] ?? '';
        
        if (contentType.contains('application/json')) {
          final Map<String, dynamic> responseBody = json.decode(response.body);
          setState(() => authToken = responseBody['token']);
        } else if (contentType.contains('application/xml')) {
          final xmlResponse = XmlDocument.parse(response.body);
          setState(() => authToken = xmlResponse
              .findAllElements('token')
              .first
              .text);
        } else {
          showError('Unsupported Content-Type: $contentType');
        }
      } else {
        showError('Registration failed: ${response.body}');
      }
    } catch (e) {
      showError('An error occurred: $e');
    }
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepPurple, Colors.purpleAccent],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 20),
                child: Form( 
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Register',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 40),
                      _buildInputField(
                        controller: nameController,
                        hint: 'First Name',
                        icon: Icons.person_outline,
                        validator: (value) =>
                            value!.isEmpty ? 'First name is required' : null,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: surnameController,
                        hint: 'Last Name',
                        icon: Icons.badge_outlined,
                        validator: (value) =>
                            value!.isEmpty ? 'Last name is required' : null,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: usernameController,
                        hint: 'Username',
                        icon: Icons.account_circle_outlined,
                        validator: (value) =>
                            value!.isEmpty ? 'Username is required' : null,
                      ),
                      const SizedBox(height: 35),
                      SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              registerUser();
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.deepPurple, Colors.purpleAccent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'REGISTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (authToken != null) ...[
                        const SizedBox(height: 25),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Your Auth Token:\n$authToken',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.deepPurple,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.deepPurple),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: Colors.deepPurple.shade300),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          errorStyle: const TextStyle(color: Color.fromARGB(255, 255, 65, 7)),
        ),
        validator: validator,
      ),
    );
  }
}