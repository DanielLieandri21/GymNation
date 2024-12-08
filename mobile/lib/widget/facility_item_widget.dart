import 'package:flutter/material.dart';

class FacilityItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;

  const FacilityItemWidget({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Gambar latar belakang
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0), // Radius gambar
            child: imageUrl == null || imageUrl!.isEmpty
                ? const Icon(
                    Icons.broken_image,
                    size: 60,
                    color: Colors.white,
                  ) // Placeholder untuk URL kosong
                : Image.network(
                    imageUrl!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.broken_image,
                        size: 60,
                        color: Colors.white,
                      ); // Placeholder jika URL tidak valid
                    },
                  ),
          ),
          // Overlay hitam semi-transparan
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          // Teks di tengah
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
