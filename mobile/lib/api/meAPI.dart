import 'package:gymnation/config/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class meAPI {
  final String apiUrl = dotenv.env['API_URL'].toString();

  Future<Map<String, dynamic>> getUserProfile() async {
    final url = Uri.parse('$apiUrl/auth/me');
    final token = await getToken();
    if (token == null) {
      return {
        'status': false,
        'message': 'Token not found. Please log in again.',
      };
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final userData = jsonResponse['data'];

        final dbHelper = DatabaseHelper();
        final existingUser = await dbHelper.getUser(userData[0][0]['id_user']);
        print("Existing user from SQLite: $existingUser");
        if (existingUser == null ||
            !_isUserDataSame(existingUser, userData[0][0])) {
          await dbHelper.insertUser({
            'id_user': userData[0][0]['id_user'],
            'first_name': userData[0][0]['first_name'],
            'last_name': userData[0][0]['last_name'],
            'email': userData[0][0]['email'],
            'img_path': userData[0][0]['img_path']
          });
        }
        return {
          'status': true,
          'data': userData,
        };
      } else {
        return {
          'status': false,
          'message': 'Failed to fetch user profile',
        };
      }
    } catch (e) {
      return {
        'status': false,
        'message': 'Error: $e',
      };
    }
  }

  bool _isUserDataSame(
      Map<String, dynamic> existingUser, Map<String, dynamic> newUser) {
    return existingUser['first_name'] == newUser['first_name'] &&
        existingUser['last_name'] == newUser['last_name'] &&
        existingUser['email'] == newUser['email'];
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
