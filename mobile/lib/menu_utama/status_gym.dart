import 'package:flutter/material.dart';
import 'package:gymnation/api/DatagymAPI.dart'; // Import API class

class StatusGym extends StatefulWidget {
  const StatusGym({super.key});

  @override
  State<StatusGym> createState() => _StatusGymState();
}

class _StatusGymState extends State<StatusGym> {
  final DatagymAPI datagymAPI = DatagymAPI();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: datagymAPI.fetchStatusGym(), // Ambil status gym dari API
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final status = snapshot.data!;
          final isOpen = status == 'open';

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(
                image: AssetImage('assets/images/background-image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 8.0,
                  left: 8.0,
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    decoration: BoxDecoration(
                      color: isOpen
                          ? Colors.green
                          : Colors.red, // Hijau untuk buka, merah untuk tutup
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Align(
                      alignment: Alignment.center, // Menempatkan teks di tengah
                      child: Text(
                        isOpen ? 'Buka' : 'Tutup',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Status gym tidak ditemukan'));
        }
      },
    );
  }
}
