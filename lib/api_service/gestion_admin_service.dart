import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class GestionAdminService {
  static const String baseUrl = ApiService.baseUrl;

  Future<Map<String, dynamic>> postCreate(
      String email,
      String firstname,
      String lastname,
      String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/gestion'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie' : ApiService.cookie
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
          'password': password,
          '_method': 'CREATE'
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
      return json.decode('{"body" : "Request timed out, server may be unreachable",'
          ' "statusCode": ${408}}');
    }
  }

  Future<Map<String, dynamic>> postDelete(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/gestion'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie' : ApiService.cookie
        },
        body: jsonEncode(<String, String>{
          'email': email,
          '_method': 'DELETE'
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
      return json.decode('{"body" : "Request timed out, server may be unreachable",'
          ' "statusCode": ${408}}');
    }
  }

  Future<List<List<String>>> get() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/gestion'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie' : ApiService.cookie
        }).timeout(const Duration(seconds: 10));

      print(json.decode(response.body).toString());
      if (response.statusCode == 200) {
        List<List<String>> nestedList = [];
        for (var element in json.decode(response.body)["msg"]) {
          if (element is List) {
            List<String> stringList = element.map((value) => value.toString()).toList();
            nestedList.add(stringList);
          }
        }
        print(nestedList);
        return nestedList;
      } else {
        return json.decode('{"body" : ${response.body}, '
            '"statusCode": ${response.statusCode}}');
      }
    } catch (e) {
      print(e);
      return json.decode('{"body" : "Request timed out, server may be unreachable",'
      ' "statusCode": ${408}}');
    }

    return [["empty"]];
  }
}