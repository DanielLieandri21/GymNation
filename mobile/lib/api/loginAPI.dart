import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAPI {
  final String apiUrl = dotenv.env['API_URL'].toString();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$apiUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        String token = jsonResponse['token'];
        await _saveToken(token);

        return {'status': true, 'token': jsonResponse['token']};
      } else {
        return {
          'status': false,
          'message': 'Login failed',
        };
      }
    } catch (e) {
      print(e);
      return {
        'status': false,
        'message': 'Error: $e',
      };
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      return true; // Logout berhasil
    } catch (e) {
      print("Error during logout: $e");
      return false; // Logout gagal
    }
  }

  // Fungsi untuk menyimpan token ke SharedPreferences
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}
