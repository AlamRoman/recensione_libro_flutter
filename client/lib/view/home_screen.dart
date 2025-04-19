import 'package:flutter/material.dart';
import 'package:gestione_recensioni/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => navController.goToRegister(),
            child: const Text('Registrati', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => navController.goToLogin(),
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
     body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Benvenuto nella piattaforma per la gestione delle recensioni!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 80),
              Text(
                'In questa piattaforma potrai:\n'
                '- Registrarti come nuovo utente\n'
                '- Effettuare il login con il tuo token\n'
                '- Visualizzare i dettagli dei libri da recensire\n'
                '- Visualizzare e gestire le tue recensioni',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}