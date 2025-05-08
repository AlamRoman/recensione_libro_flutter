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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ink Review',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurple, // Custom button color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/books': (context) => const BooksContent(),
        '/reviews': (context) => const ReviewsContent(),
        '/userProfile': (context) => const UserProfileScreen(),
      },
    );
  }
}
