import 'package:flutter/material.dart';
import 'package:gestione_recensioni/main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // TODO Aggiungere funzione richiesta login

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => navController.goToHome(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.deepPurple,
                ),
              ),
              child: TextField(
                controller: loginController,
                decoration: const InputDecoration(
                  hintText: 'Inserisci il token',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Aggiungere funzione richiesta login
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
