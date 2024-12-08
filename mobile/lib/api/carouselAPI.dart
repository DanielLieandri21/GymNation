import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CarouselAPI {
  final String apiUrl = dotenv.env['API_URL'].toString();

  // Fungsi untuk mendapatkan data carousel
  Future<List<Map<String, String>>> fetchCarouselData() async {
    final url = Uri.parse('$apiUrl/carousel/getCarousel');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];

        // Casting data ke List<Map<String, String>>
        return data.map<Map<String, String>>((item) {
          return {
            'image': item['img_path'] as String,
            'text': item['title'] as String,
          };
        }).toList();
      } else {
        throw Exception("Failed to load carousel data: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching carousel data: $e");
    }
  }
}
