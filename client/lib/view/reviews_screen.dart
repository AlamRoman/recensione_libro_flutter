import 'package:flutter/material.dart';
import 'package:ink_review/control/review_controller.dart';
import 'package:ink_review/model/recensione.dart';
import 'package:ink_review/view/books_screen.dart';
import 'package:ink_review/view/home_content.dart';
import 'package:ink_review/view/settings_content.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  int _currentIndex = 2;

  final List<Widget> _screens = [
    const HomeContent(),
    const BooksContent(),
    const ReviewsContent(),
    const SettingContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Row(
              children: [
                Image.asset(
                  '../resources/logo.png',
                  height: 40,
                ),
                const SizedBox(width: 15),
                const Text(
                  'Ink Review',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.purpleAccent],
          ),
        ),
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Books',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review),
              label: 'My Reviews',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewsContent extends StatefulWidget {
  const ReviewsContent({super.key});

  @override
  State<ReviewsContent> createState() => _ReviewsContentState();
}

class _ReviewsContentState extends State<ReviewsContent> {
  late Future<List<Recensione>> _reviewsFuture;

  @override
  void initState() {
    super.initState();
    _reviewsFuture = ReviewController('http://localhost/web_service/ink_review').fetchReview();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Recensione>>(
      future: _reviewsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No reviews found', style: TextStyle(color: Colors.white)));
        }

        final reviews = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReviewDetailScreen(review: review)),
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.deepPurple,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  title: Text('Book ID: ${review.id_libro}', style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Rating: ${review.voto.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white70)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ReviewDetailScreen extends StatefulWidget {
  final Recensione review;
  const ReviewDetailScreen({super.key, required this.review});

  @override
  State<ReviewDetailScreen> createState() => _ReviewDetailScreenState();
}

class _ReviewDetailScreenState extends State<ReviewDetailScreen> {
  late TextEditingController _votoController;
  late TextEditingController _commentoController;
  late Recensione _review;

  @override
  void initState() {
    super.initState();
    _review = widget.review;
    _votoController = TextEditingController(text: _review.voto.toString());
    _commentoController = TextEditingController(text: _review.commento ?? '');
  }

  @override
  void dispose() {
    _votoController.dispose();
    _commentoController.dispose();
    super.dispose();
  }

  void _save() async {
    final newVoto = double.tryParse(_votoController.text);
    final newCommento = _commentoController.text;
    if (newVoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid grade')));
      return;
    }

    final bool votoChanged = newVoto != _review.voto;
    final bool commentChanged = newCommento != (_review.commento ?? '');

    try {
      if (votoChanged && commentChanged) {
        await ReviewController.updateReview(
          apiUrl: 'http://localhost/web_service/ink_review',
          idRecensione: _review.id,
          voto: newVoto,
          commento: newCommento,
        );
      } else if (votoChanged || commentChanged) {
        await ReviewController.patchReview(
          apiUrl: 'http://localhost/web_service/ink_review',
          idRecensione: _review.id,
          voto: votoChanged ? newVoto : null,
          commento: commentChanged ? newCommento : null,
        );
      }

      setState(() {
        _review.voto = newVoto;
        _review.commento = newCommento;
        _review.data_ultima_modifica = DateTime.now();
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review Updated!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                Image.asset('../resources/logo.png', height: 40),
                const SizedBox(width: 15),
                const Text('Ink Review', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.purpleAccent],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _fielContainer('ID Recensione', _review.id.toString()),
              const SizedBox(height: 8),
              _fielContainer('ID Libro', _review.id_libro.toString()),
              const SizedBox(height: 8),
              _buildInputField(controller: _votoController, hint: 'Voto', icon: Icons.star),
              const SizedBox(height: 8),
              _buildInputField(controller: _commentoController, hint: 'Commento', icon: Icons.comment),
              const SizedBox(height: 8),
              _fielContainer('Ultima modifica', _review.data_ultima_modifica.toString()),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Back', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fielContainer(String title, String value) {
    return Card(
      color: Colors.white.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.deepPurple,
            blurRadius: 12,
            offset: Offset(0, 6),
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
        ),
      ),
    );
  }
}
