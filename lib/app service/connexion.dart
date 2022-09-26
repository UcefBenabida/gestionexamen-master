import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Connexion {
  static const String apiUrl = 'http://192.168.43.101:8080/';
  Map<String, String> headers = {"Content-Type": "application/json"};

  Future<bool> testInternetConnexion() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<http.Response> postData(Map<String, String> body, serviceUrl) async {
    var fullUrl = Uri.parse("${Connexion.apiUrl}$serviceUrl");
    try {
      return await http.post(fullUrl, body: jsonEncode(body), headers: headers);
    } catch (_) {
      return http.Response('{"error" : "connexion error"}', 400);
    }
  }

  Future<http.Response> getData(serviceUrl) async {
    var fullUrl = Uri.parse("${Connexion.apiUrl}$serviceUrl");
    try {
      return await http.get(fullUrl, headers: headers);
    } catch (_) {
      return http.Response('{"error" : "connexion error"}', 400);
    }
  }
}
