import 'dart:convert';
import 'dart:io';
import 'package:gymnation/api/meAPI.dart';
import 'package:gymnation/config/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class UserAPI {
  final String apiUrl = dotenv.env['API_URL'].toString();
  final meAPI meapi = meAPI();
  final DatabaseHelper dbHelper = DatabaseHelper();

  Future<bool> updateProfile({
    required int idUser,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      return false;
    }

    final url = Uri.parse('$apiUrl/user/updateProfile/$idUser');

    try {
      final body = {
        "id_user": idUser,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
      };

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> forgetPassword({required String email}) async {
    final url = Uri.parse('$apiUrl/user/forgetPassword');

    try {
      final body = {
        "email": email,
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> changePassword(
      {required String newPass, required int idUser}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      return false;
    }

    final url = Uri.parse('$apiUrl/user/changePassword');

    try {
      final body = {
        "id_user": idUser,
        "newPass": newPass,
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      final responseData = jsonDecode(response.body);
      print('Response from server: $responseData');
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> changeProfilePict(
      {required File profile_pict, required int id_user}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token == null) {
      return false;
    }

    final url = Uri.parse('$apiUrl/user/updateProfilePicture/$id_user');
    try {
      var request = http.MultipartRequest("PATCH", url);

      request.headers['Authorization'] = 'Bearer $token';

      if (await profile_pict.exists()) {
        final mimeType = lookupMimeType(profile_pict.path);
        request.files.add(await http.MultipartFile.fromPath(
            'profile_pict', profile_pict.path,
            contentType: MediaType.parse(mimeType ?? 'image/png')));
      } else {
        print('File tidak ditemukan di path: ${profile_pict.path}');
        return false;
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Gagal memperbarui foto: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
