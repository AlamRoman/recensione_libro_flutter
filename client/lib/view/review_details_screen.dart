import 'package:flutter/material.dart';
import 'package:ink_review/control/review_controller.dart';
import 'package:ink_review/model/recensione.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid grade')),
      );
      return;
    }

    final bool votoChanged = newVoto != _review.voto;
    final bool commentChanged = newCommento != (_review.commento ?? '');

    if (!votoChanged && !commentChanged) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No changes detected')),
      );
      return;
    }

    try {
      if (votoChanged && commentChanged) {
        await ReviewController.updateReview(
          apiUrl: 'http://localhost/web_service/ink_review',
          idRecensione: _review.id,
          voto: newVoto,
          commento: newCommento,
        );
      } else {
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  void _deleteReview() async {
    try {
      await ReviewController.deleteReview(
        apiUrl: 'http://localhost/web_service/ink_review',
        idRecensione: _review.id,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Review Details',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
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
              const SizedBox(height: 20),
              _buildLockedField('Review ID', _review.id.toString()),
              const SizedBox(height: 12),
              _buildLockedField('Book ID', _review.id_libro.toString()),
              const SizedBox(height: 12),
              _buildEditableField(
                controller: _votoController,
                hint: 'Rating',
                icon: Icons.star,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildEditableField(
                controller: _commentoController,
                hint: 'Comment',
                icon: Icons.comment,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildLockedField(
                'Last Modified',
                _review.data_ultima_modifica?.toString() ?? 'Not available',
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionButton(
                    text: 'Delete',
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: _deleteReview,
                  ),
                  const SizedBox(width: 20),
                  _buildActionButton(
                    text: 'Save',
                    icon: Icons.save,
                    color: Colors.deepPurple,
                    onPressed: _save,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockedField(String label, String value) {
    return TextFormField(
      readOnly: true,
      initialValue: value,
      style: const TextStyle(color: Colors.white70),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: const Icon(Icons.lock_outline, color: Colors.white54),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        prefixIcon: Icon(icon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(text, style: TextStyle(color: Colors.white)),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}