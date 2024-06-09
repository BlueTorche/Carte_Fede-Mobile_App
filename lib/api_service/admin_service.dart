import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class AdminService {
  static const String baseUrl = ApiService.baseUrl;

  Future<Map<String, dynamic>> post(
      String email,
      String firstname,
      String lastname,
      String study_year,
      String validity_year,
      String card_number) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': ApiService.cookie
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
          'study_year': study_year,
          'validity_year': validity_year,
          'card_number': card_number,
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
/**/