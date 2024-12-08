import 'package:flutter/material.dart';
import 'package:gymnation/login_screen/styles.dart';
import 'package:gymnation/menu_utama/food_page.dart';
import 'package:gymnation/menu_utama/class_page.dart';
import 'package:gymnation/menu_utama/discount_page.dart';
import 'package:gymnation/menu_utama/facility_page.dart';
import 'package:gymnation/widget/all_list_item.dart';

class SeeAllPage extends StatefulWidget {
  const SeeAllPage({super.key});

  @override
  _SeeAllPageState createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final List<Map<String, dynamic>> _items = [
    {
      'icon': Icons.restaurant,
      'title': 'Makanan',
      'subtitle': 'Lihat berbagai pilihan makanan sehat.',
      'page': FoodPage(),
    },
    {
      'icon': Icons.list,
      'title': 'Fasilitas',
      'subtitle': 'Temukan fasilitas yang tersedia di sini.',
      'page': const FacilityPage(),
    },
    {
      'icon': Icons.percent,
      'title': 'Diskon',
      'subtitle': 'Cek promo dan diskon menarik.',
      'page': const DiscountPage(),
    },
    {
      'icon': Icons.event_note,
      'title': 'Kelas',
      'subtitle': 'Daftar kelas yang tersedia untuk Anda.',
      'page': const ClassPage(),
    },
  ];

  String _searchQuery = "";

  // Filter item berdasarkan query
  List<Map<String, dynamic>> get _filteredItems {
    if (_searchQuery.isEmpty) return _items;
    return _items
        .where((item) =>
            item['title'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
            item['subtitle'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('See All', style: TextStyles.title),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade700, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Search Bar berada di bawah AppBar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value; // Update query pencarian
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Cari konten...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            // Daftar Item
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  return ListItemWidget(
                    icon: item['icon'],
                    title: item['title'],
                    subtitle: item['subtitle'],
                    page: item['page'],
                    backgroundColor: Colors.orange,
                    iconColor: Colors.white,
                    titleColor: Colors.white,
                    subtitleColor: Colors.white,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
