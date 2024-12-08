import 'package:flutter/material.dart';

class FoodMenuItem extends StatelessWidget {
  final String name;
  final String? imageUrl; // URL dapat berupa null

  const FoodMenuItem({
    super.key,
    required this.name,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.orange[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: SizedBox(
            width: 60, // Ukuran lebar tetap untuk gambar atau ikon
            height: 60, // Ukuran tinggi tetap untuk gambar atau ikon
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Radius gambar
              child: imageUrl == null || imageUrl!.isEmpty
                  ? const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.white,
                    ) // Placeholder untuk URL kosong
                  : Image.network(
                      imageUrl!,
                      width: 60,
                      height: 60,
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
          ),
          title: Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          subtitle: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.white, size: 16),
                  Icon(Icons.star, color: Colors.white, size: 16),
                  Icon(Icons.star, color: Colors.white, size: 16),
                  Icon(Icons.star, color: Colors.white, size: 16),
                  Icon(Icons.star, color: Colors.white, size: 16),
                ],
              ),
              SizedBox(height: 8), // Jarak vertikal antara bintang dan teks
              Text(
                'Klik Info Selengkapnya',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ));
  }
}
