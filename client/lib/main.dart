import 'package:flutter/material.dart';
import 'package:ink_review/view/books_screen.dart';
import 'package:ink_review/view/home.dart';
import "package:ink_review/view/login_screen.dart";
import 'package:ink_review/view/register_screen.dart';
import 'package:ink_review/view/reviews_screen.dart';
import 'package:ink_review/view/user_profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ink Review',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/books': (context) => const BooksContent(),
        '/reviews': (context) => const ReviewsContent(),
        '/userProfile': (context) => const UserProfileScreen(),
      },
    );
  }
}
