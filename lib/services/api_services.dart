import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'https://hono-todoappbackend1.onrender.com/api/v1';

  static Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/login"),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );
    // print(response.body);
    if (response.statusCode == 200) {
       final setCookie = response.headers['set-cookie'];
      //  print(setCookie);
       if(setCookie!=null){
        final jwtCookie = setCookie.split(';')[0];
        final cookie = jwtCookie.split('=')[1];
        // print(jwtCookie);
        // print(cookie);
        final prefs = await SharedPreferences.getInstance();
         await prefs.setString('token', cookie);
       }
      return null;
    } else {
      String? err = jsonDecode(response.body)["data"][0]["message"];
      return err;
    }
  }

  static Future<String?> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/users/register"),
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
      headers: {"Content-Type": "application/json"},
    );
    // print(response.body);
    if (response.statusCode == 200) {
      return null;
    } else {
      String? err = jsonDecode(response.body)["data"][0]["message"];
      return err;
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}
