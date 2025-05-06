import 'package:flutter/material.dart';
import 'package:ink_review/view/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController loginController = TextEditingController();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
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
                    constraints: BoxConstraints(
                      minHeight:
                          screenHeight - MediaQuery.of(context).padding.vertical,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          '../resources/logo.png',
                          height: 200,
                          width: 200,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Ink Review',
                          style:
                              Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              const BoxShadow(
                                color: Colors.deepPurple,
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: loginController,
                            style: const TextStyle(color: Colors.deepPurple),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.transparent,
                              hintText: 'Enter your token',
                              hintStyle:
                                  TextStyle(color: Colors.grey.shade400),
                              prefixIcon: Icon(
                                Icons.vpn_key_rounded,
                                color: Colors.deepPurple.shade300,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
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
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.deepPurple,
                                    Colors.purpleAccent
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                child: const Text(
                                  'LOGIN',
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
                        const SizedBox(height: 25),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: const TextStyle(color: Colors.white70),
                              children: [
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: _ContentTypeDropdown(),
          ),
        ],
      ),
    );
  }
}

class _ContentTypeDropdown extends StatefulWidget {
  @override
  State<_ContentTypeDropdown> createState() => _ContentTypeDropdownState();
}

class _ContentTypeDropdownState extends State<_ContentTypeDropdown> {
  String selected = 'XML';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        height: 40,
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: DropdownButton<String>(
          value: selected,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
          dropdownColor: Colors.white,
          items: const [
            DropdownMenuItem(
              value: 'XML',
              child: Text('XML'),
            ),
            DropdownMenuItem(
              value: 'JSON',
              child: Text('JSON'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selected = value!;
              // Use `selected` as needed
              print('Selected content type: $selected');
            });
          },
        ),
      ),
    );
  }
}
