import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gymnation/api/carouselAPI.dart';
import 'package:gymnation/menu_utama/class_page.dart';
import 'package:gymnation/menu_utama/discount_page.dart';
import 'package:gymnation/menu_utama/facility_page.dart';
import 'package:gymnation/menu_utama/food_page.dart';
import 'package:gymnation/menu_utama/see_all_page.dart';
import 'package:gymnation/menu_utama/status_gym.dart';

class HomePageContent extends StatefulWidget {
  final bool isSearching;
  final String searchQuery;
  final ValueChanged<String> onSearchQueryChanged;

  const HomePageContent({
    super.key,
    required this.isSearching,
    required this.searchQuery,
    required this.onSearchQueryChanged,
  });

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  List<Map<String, String>> _carouselData = [];
  bool _isLoading = true; // Menandai jika data masih diambil

  @override
  void initState() {
    super.initState();
    _fetchCarouselData();
  }

  Future<void> _fetchCarouselData() async {
    try {
      final data = await CarouselAPI().fetchCarouselData();
      setState(() {
        _carouselData = data;
        _isLoading = false; // Data berhasil diambil
      });
    } catch (e) {
      print("Error fetching carousel: $e");
      setState(() {
        _isLoading = false; // Tetap hentikan loader jika ada error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.isSearching)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: widget.onSearchQueryChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Cari Makanan, Kelas, Fasilitas, atau Diskon...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          // Tampilkan loader saat data diambil
          if (_isLoading)
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.orange, // Warna indikator
              ),
            )
          else if (_carouselData.isNotEmpty)
            CarouselSlider(
              options: CarouselOptions(
                height: 225.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
              ),
              items: _carouselData.map((item) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: NetworkImage(item['image']!), // Gambar dari API
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Text(
                        item['text']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          else
            const Text(
              "Tidak ada data carousel.",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          const SizedBox(height: 16),
          // GridView for Menu Items
          // Tambahkan ini di dalam widget HomeContent
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Membuat teks rata kiri
              children: [
                // Tambahkan teks "Fitur Aplikasi"
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Margin kiri-kanan
                  child: const Text(
                    'Fitur Aplikasi', // Teks fitur aplikasi
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Ukuran font
                      fontWeight: FontWeight.bold, // Teks bold
                    ),
                  ),
                ),
                const SizedBox(height: 12), // Jarak antara teks dan menu
                // ListView Builder untuk menu
                SizedBox(
                  height: 100, // Tinggi menu bar
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Scroll horizontal
                    itemCount: 5, // Jumlah item menu
                    itemBuilder: (context, index) {
                      // Data Menu
                      final menuItems = [
                        {
                          'icon': Icons.grid_view,
                          'title': 'Lihat Semua',
                          'page': SeeAllPage()
                        },
                        {
                          'icon': Icons.restaurant,
                          'title': 'Makanan',
                          'page': FoodPage()
                        },
                        {
                          'icon': Icons.event_note,
                          'title': 'Kelas',
                          'page': ClassPage()
                        },
                        {
                          'icon': Icons.percent,
                          'title': 'Diskon',
                          'page': DiscountPage()
                        },
                        {
                          'icon': Icons.list,
                          'title': 'Fasilitas',
                          'page': FacilityPage()
                        },
                      ];

                      // MenuItem Widget
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    menuItems[index]['page'] as Widget),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 70, // Tinggi bulatan
                                width: 70, // Lebar bulatan
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 255, 157, 0),
                                        Color.fromARGB(255, 248, 145, 1),
                                      ],
                                    )),

                                child: Icon(
                                  menuItems[index]['icon'] as IconData,
                                  color: Colors.white,
                                  size: 36, // Ukuran ikon
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                menuItems[index]['title'] as String,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 180, // Berikan tinggi tetap
                  child: StatusGym(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
