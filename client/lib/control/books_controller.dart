import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../model/libro.dart';
import 'package:ink_review/model/global_vars.dart';

class BookController {
  final String apiUrl;

  BookController(this.apiUrl);

  Future<List<Libro>> fetchBooks() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Auth-Token' : userToken,
        "content-type": globalContentType,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load books');
    }

    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      return _parseJson(response.body);
    } else if (contentType.contains('application/xml') || contentType.contains('text/xml')) {
      return _parseXml(response.body);
    } else {
      throw Exception('Unsupported content type: $contentType');
    }
  }

  List<Libro> _parseJson(String body) {
    final List<dynamic> decoded = jsonDecode(body);
    return decoded.map((item) => Libro.fromJson(item)).toList();
  }

  List<Libro> _parseXml(String body) {
    final document = XmlDocument.parse(body);
    final books = <Libro>[];

    for (final element in document.findAllElements('item')) {
      books.add(Libro(
        id: int.parse(element.findElements('id').single.text),
        titolo: element.findElements('titolo').single.text,
        autore: element.getElement('autore')?.text,
        descrizione: element.getElement('descrizione')?.text,
        isbn: element.findElements('isbn').single.text,
        genere: element.getElement('genere')?.text,
        anno_pubblicazione: element.getElement('anno_pubblicazione') != null
            ? DateTime.tryParse(element.getElement('anno_pubblicazione')!.text)
            : null,
      ));
    }

    return books;
  }
}
