import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ChangeCredentialService {
  static const String baseUrl = ApiService.baseUrl;

  Future<Map<String, dynamic>> postChange(String password, String oldPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/change_password'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': ApiService.cookie
        },
        body: jsonEncode(<String, String>{
          'password': password,
          'oldPassword': oldPassword,
        }),
      ).timeout(const Duration(seconds: 10));

      print(json.decode(response.body).toString());
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode('{"body" : ${response.body}, '
            '"statusCode": ${response.statusCode}}');
      }
    } catch (e) {
      print(e);
      return json.decode(
          '{"body" : "Request timed out, server may be unreachable",'
              ' "statusCode": ${408}}');
    }
  }
}