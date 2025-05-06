import 'package:flutter/material.dart';
import 'package:ink_review/main.dart';
import 'package:ink_review/view/login_screen.dart';
import 'package:ink_review/view/register_screen.dart';

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
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen())),
            child: const Text('Registrati', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen())),
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