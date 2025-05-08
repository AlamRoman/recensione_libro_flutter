import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import '../model/users.dart';
import 'package:ink_review/model/global_vars.dart';

class UserController {
  UserController();

  Future<Users> fetchUser(String apiUrl) async {
    final uri = Uri.parse(apiUrl);
    final response = await http.get(
      uri,
      headers: {
        'Auth-Token': userToken,
        'Content-Type': globalContentType,
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load user (status ${response.statusCode})');
    }

    final contentType = response.headers['content-type'] ?? '';
    if (contentType.contains('application/json')) {
      return _parseJson(response.body);
    } else if (contentType.contains('application/xml') ||
               contentType.contains('text/xml')) {
      return _parseXml(response.body);
    } else {
      throw Exception('Unsupported content type: $contentType');
    }
  }

  Future<void> updateUser(Users user, String apiUrl) async {
    final uri = Uri.parse(apiUrl);
    var body;
    String contentTypeHeader = globalContentType;

    if (globalContentType == 'application/json') {
      body = json.encode({
        'operation': 'update_user_details',
        'nome': user.nome,
        'cognome': user.cognome
      });
    } else if (globalContentType == 'application/xml') {
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0" encoding="UTF-8"');
      builder.element('request', nest: () {
        builder.element('operation', nest: 'update_user_details');
        builder.element('nome', nest: user.nome);
        builder.element('cognome', nest: user.cognome);
      });
      body = builder.buildDocument().toXmlString();
    }

    final response = await http.patch(
      uri,
      headers: {
        'Auth-Token': userToken,
        'Content-Type': contentTypeHeader,
      },
      body: body,
    );

    // Handle response parsing
    final responseContentType = response.headers['content-type']?.split(';').first;
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return;
    }

    String errorMessage = 'Unknown error';
    if (responseContentType == 'application/json') {
      final errorData = json.decode(response.body);
      errorMessage = errorData['message'] ?? errorData.toString();
    } else if (responseContentType == 'application/xml') {
      final xmlDoc = XmlDocument.parse(response.body);
      errorMessage = xmlDoc.findAllElements('message').first.text;
    }

    throw Exception('Failed to update user: $errorMessage (${response.statusCode})');
  }

  Users _parseJson(String body) {
    final Map<String, dynamic> decoded = jsonDecode(body);
    return Users.fromJson(decoded);
  }

  Users _parseXml(String body) {
    final document = XmlDocument.parse(body);
    final item = document.findAllElements('item').first;
    return Users(
      id: int.parse(item.findElements('id').single.text),
      nome: item.getElement('nome')?.text,
      cognome: item.getElement('cognome')?.text,
      username: item.findElements('username').single.text,
      token: item.getElement('token')?.text,
    );
  }
}
