import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class QRCodeService {
  static const String baseUrl = ApiService.baseUrl;

  Future<Map<String, dynamic>> get() async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/qrcode'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Cookie' : ApiService.cookie
          }).timeout(const Duration(seconds: 10));

      print(json.decode(response.body).toString());
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return json.decode('{"msg" : ${response.body}, '
            '"statusCode": ${response.statusCode}}');
      }
    } catch (e) {
      print(e);
      return json.decode('{"body" : "Request timed out, server may be unreachable",'
          ' "statusCode": ${408}}');
    }
  }
}