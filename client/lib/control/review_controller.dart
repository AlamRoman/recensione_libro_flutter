import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ink_review/model/recensione.dart';
import 'package:xml/xml.dart';
import 'package:ink_review/model/global_vars.dart';

class ReviewController {
  final String apiUrl;

  ReviewController(this.apiUrl);

  Future<List<Recensione>> fetchReview() async {
    final url = Uri.parse('$apiUrl/list_user_reviews');
    final response = await http.get(
      url,
      headers: {
        'Auth-Token': userToken,
        'Content-Type': globalContentType,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load reviews: ${response.statusCode}');
    }

    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      return _parseJson(response.body);
    } else if (contentType.contains('xml')) {
      return _parseXml(response.body);
    } else {
      throw Exception('Unsupported content type: $contentType');
    }
  }

  List<Recensione> _parseJson(String body) {
    final List<dynamic> decoded = jsonDecode(body);
    return decoded.map((item) => Recensione.fromJson(item as Map<String, dynamic>)).toList();
  }

  List<Recensione> _parseXml(String body) {
    final document = XmlDocument.parse(body);
    final reviews = <Recensione>[];
    for (final element in document.findAllElements('Recensione')) {
      reviews.add(Recensione(
        id: int.parse(element.findElements('id').single.text),
        id_user: int.parse(element.findElements('id_user').single.text),
        id_libro: int.parse(element.findElements('id_libro').single.text),
        voto: double.parse(element.findElements('voto').single.text),
        commento: element.getElement('commento')?.text,
        data_ultima_modifica: element.getElement('data_ultima_modifica') != null
            ? DateTime.tryParse(element.getElement('data_ultima_modifica')!.text)
            : null,
      ));
    }
    return reviews;
  }

  static Future<void> updateReview({
    required String apiUrl,
    required int idRecensione,
    required double voto,
    required String commento,
  }) async {
    final uri = Uri.parse('$apiUrl/review/update/$idRecensione');
    final body = jsonEncode({
      'id_recensione': idRecensione, 
      'voto': voto,
      'commento': commento,
    });
    final response = await http.put(uri, headers: {
      'Auth-Token': userToken,
      'Content-Type': globalContentType,
    }, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to update review: ${response.statusCode}');
    }
  }

  static Future<void> patchReview({
    required String apiUrl,
    required int idRecensione,
    double? voto,
    String? commento,
  }) async {
    final uri = Uri.parse('$apiUrl/review/partial_update/$idRecensione');
    final bodyMap = <String, dynamic>{
      'id_recensione': idRecensione,
      if (voto     != null) 'voto': voto,
      if (commento != null) 'commento': commento,
    };
    final response = await http.patch(uri, headers: {
      'Auth-Token': userToken,
      'Content-Type': globalContentType,
    }, body: jsonEncode(bodyMap));

    if (response.statusCode != 200) {
      throw Exception('Failed to patch review: ${response.statusCode}');
    }
  }

}
