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
    final decoded = jsonDecode(body);

    List<dynamic> reviewsData = [];
    if (decoded is List) {
      reviewsData = decoded;
    } else if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('reviews')) {
        reviewsData = decoded['reviews'];
      } else if (decoded.containsKey('data')) {
        reviewsData = decoded['data'];
      } else {
        throw FormatException('Unexpected JSON format');
      }
    } else {
      throw FormatException('Root JSON element must be list or map');
    }

    return reviewsData.map<Recensione>((item) {
      return Recensione.fromJson(item as Map<String, dynamic>);
    }).toList();
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
    var body;
    final headers = {
      'Auth-Token': userToken,
      'Content-Type': globalContentType,
    };

    if (globalContentType == 'application/json') {
      body = jsonEncode({
        'id_recensione': idRecensione,
        'voto': voto,
        'commento': commento,
      });
    } else if (globalContentType == 'application/xml') {
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('request', nest: () {
        builder.element('id_recensione', nest: idRecensione);
        builder.element('voto', nest: voto);
        builder.element('commento', nest: commento);
      });
      body = builder.buildDocument().toXmlString();
    }

    final response = await http.put(uri, headers: headers, body: body);
    if (response.statusCode != 200) {
      throw await _parseError(response, 'Failed to update review');
    }
  }

  static Future<void> patchReview({
    required String apiUrl,
    required int idRecensione,
    double? voto,
    String? commento,
  }) async {
    final uri = Uri.parse('$apiUrl/review/partial_update/$idRecensione');
    final headers = {
      'Auth-Token': userToken,
      'Content-Type': globalContentType,
    };
    var body;

    final payload = {
      'id_recensione': idRecensione,
      if (voto != null) 'voto': voto,
      if (commento != null) 'commento': commento,
    };

    if (globalContentType == 'application/json') {
      body = jsonEncode(payload);
    } else if (globalContentType == 'application/xml') {
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('request', nest: () {
        payload.forEach((key, value) {
          if (value != null) builder.element(key, nest: value);
        });
      });
      body = builder.buildDocument().toXmlString();
    }

    final response = await http.patch(uri, headers: headers, body: body);
    if (response.statusCode != 200) {
      throw await _parseError(response, 'Failed to patch review');
    }
  }

  static Future<void> deleteReview({
    required String apiUrl,
    required int idRecensione,
  }) async {
    final uri = Uri.parse('$apiUrl/review/delete/$idRecensione');
    final headers = {
      'Auth-Token': userToken,
      'Content-Type': globalContentType,
    };

    final response = await http.delete(uri, headers: headers);
    if (response.statusCode != 200) {
      throw await _parseError(response, 'Failed to delete review');
    }
  }

  static Future<Exception> _parseError(http.Response response, String defaultMessage) async {
    final contentType = response.headers['content-type'] ?? '';
    String message = defaultMessage;

    try {
      if (contentType.contains('application/json')) {
        final error = jsonDecode(response.body);
        message = error['message'] ?? error.toString();
      } else if (contentType.contains('xml')) {
        final document = XmlDocument.parse(response.body);
        message = document.findAllElements('message').first.text;
      }
    } catch (_) {}

    return Exception('$message (HTTP ${response.statusCode})');
  }

}
