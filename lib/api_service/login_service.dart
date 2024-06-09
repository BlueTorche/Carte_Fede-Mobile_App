import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async'; // Import the necessary library for TimeoutException
import 'api_service.dart';

class LoginService {
  static const String baseUrl = ApiService.baseUrl;

  Future<Map<String, dynamic>> post(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 10));

      ApiService.cookie = response.headers['set-cookie'].toString();
      print(response.headers);

      print(json.decode(response.body).toString());
      if (response.statusCode == 200) {
        final answer = json.decode(response.body);
        print(answer["role"]);
        if (answer["role"] == 1) {
          ApiService.role=1;
        } else {
          ApiService.role=0;
        }
        return answer;
      } else {
        return json.decode('{"body" : ${response.body}, '
            '"statusCode": ${response.statusCode}}');
      }
    } on TimeoutException catch (_) {
      print("Request timed out, server may be unreachable");
      return json.decode('{"body" : "Request timed out, server may be unreachable",'
          ' "statusCode": 408}');
    } catch (e) {
      print(e);
      return json.decode('{"body" : "An error occurred : ${e.toString()}", "statusCode": 500}');
    }
  }
}
