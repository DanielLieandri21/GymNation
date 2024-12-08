import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatagymAPI {
  final String apiUrl = dotenv.env['API_URL'].toString();

  Future<List<dynamic>> fetchMakanan() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/makanan/getAllMakanan'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception(
            'Gagal mengambil data makanan. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<dynamic>> fetchKelas() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/kelas/getAllKelas'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception(
            'Gagal mengambil data kelas. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<dynamic>> fetchDiskon() async {
    try {
      final response = await http
          .get(Uri.parse('$apiUrl/potonganHarga/getAllPotonganHarga'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception(
            'Gagal mengambil data diskon. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<List<dynamic>> fetchFasilitas() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl/fasilitas/getAllFasilitas'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        print(jsonResponse['data']);
        return jsonResponse['data'];
      } else {
        throw Exception(
            'Gagal mengambil data fasilitas. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  Future<String> fetchStatusGym() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/status/getStatusGYM'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final status = jsonResponse['data'][0]['status'];
        print(status);
        return status;
      } else {
        throw Exception(
            'Gagal mengambil data status gym. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
