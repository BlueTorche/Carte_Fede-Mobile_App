import 'package:http/http.dart' as http;

class ApiService {
  static const String domainName = 'https://carte.fede.fpms.ac.be';
  static const String baseUrl = '$domainName/api';
  static String cookie = "";
  static int role = 0;

  static void logout() async {
    try {
      await http.get(Uri.parse('$domainName/logout'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Cookie': ApiService.cookie
          }).timeout(const Duration(seconds: 10));
    } catch (e) {
      print(e);
    } finally {
      cookie = "";
      role = 0;
    }
  }
}
