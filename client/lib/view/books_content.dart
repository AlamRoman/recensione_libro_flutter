import 'package:flutter/material.dart';
import '../control/books_controller.dart';
import '../../model/libro.dart';

class BooksContent extends StatefulWidget {
  const BooksContent({super.key});

  @override
  State<BooksContent> createState() => _BooksContentState();
}

class _BooksContentState extends State<BooksContent> {
  late Future<List<Libro>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _booksFuture = BookController('http://localhost/web_service/ink_review/list_books').fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Libro>>(
      future: _booksFuture,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No books found', style: TextStyle(color: Colors.white)));
        }

        final books = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Books List',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    color: Colors.white.withOpacity(0.1),
                    child: ListTile(
                      title: Text(book.titolo, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(book.autore ?? 'Unknown Author', style: TextStyle(color: Colors.white70)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
