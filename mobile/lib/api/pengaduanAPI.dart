import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PengaduanAPI {
  final String apiUrl = dotenv.env['API_URL'].toString();

  Future<bool> addPengaduan({
    required String name,
    required String email,
    required String no_telpon,
    required String pesan,
  }) async {
    final url = Uri.parse('$apiUrl/pengaduan/addPengaduan');

    try {
      final body = {
        "nama": name,
        "email": email,
        "no_telpon": no_telpon,
        "pesan": pesan
      };

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response from server: $responseData');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
