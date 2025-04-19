import 'package:flutter/material.dart';
import 'package:gestione_recensioni/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>(); //Per poter controllare se i campi sono validi
  String? authToken;

  // TODO Funzione per eseguire la richiesta e ottenere il token in risposta

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrazione',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => navController.goToHome(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form( 
          key: formKey,
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
                child: TextFormField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Nome",
                    prefixIcon: Icon(Icons.person),
                    border: InputBorder.none,
                  ),
                  // Aggiungi validazione per il campo Nome
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Il nome è obbligatorio';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepPurple,
                  ),
                ),
                child: TextFormField(
                  controller: surnameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Cognome",
                    prefixIcon: Icon(Icons.badge),
                    border: InputBorder.none,
                  ),
                  // Aggiungi validazione per il campo Cognome
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Il cognome è obbligatorio';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.deepPurple,
                  ),
                ),
                child: TextFormField(
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: "Username",
                    prefixIcon: Icon(Icons.account_circle),
                    border: InputBorder.none,
                  ),
                  // Aggiungi validazione per il campo Username
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'L\'username è obbligatorio';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:  () {
                  // Aggiungere funzione richiesta registrazione
                },
                  child: const Text("Registrati"),
                ),
              ),
              if (authToken != null) ...[
                const SizedBox(height: 20),
                Text(
                  'Token per l\'autentificazione:\n$authToken',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
