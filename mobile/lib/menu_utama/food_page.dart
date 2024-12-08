import 'package:flutter/material.dart';
import 'package:gymnation/api/DatagymAPI.dart';
import 'package:gymnation/login_screen/styles.dart';
import 'package:gymnation/widget/foodmenu_item.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  List<dynamic> _makananList = [];
  bool _isLoading = true;
  final DatagymAPI datagymAPI = DatagymAPI();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final makananData = await datagymAPI.fetchMakanan();
      setState(() {
        _makananList = makananData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Healthy Food',
          style: TextStyles.title,
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade700, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Deskripsi
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/images/healthy-food.png', // Gambar lokal
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                const Positioned(
                  left: 16,
                  bottom: 16,
                  child: Text(
                    'Healthy Food',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Healthy Food atau makanan sehat adalah jenis makanan yang memberikan manfaat nutrisi bagi tubuh dan mendukung kesehatan secara keseluruhan. Makanan ini biasanya kaya akan vitamin, mineral, serat, dan antioksidan, serta rendah akan gula, garam, dan lemak jenuh.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Food Menu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Daftar Makanan
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _makananList.isEmpty
                    ? const Center(
                        child: Text(
                          'Tidak ada data makanan.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _makananList.length,
                          itemBuilder: (context, index) {
                            final makanan = _makananList[index];
                            return GestureDetector(
                              onTap: () {
                                _showDetailModal(
                                  context,
                                  makanan['title'],
                                  makanan['deskripsi'],
                                );
                              },
                              child: FoodMenuItem(
                                name: makanan['title'],
                                imageUrl: makanan['img_path'],
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  void _showDetailModal(BuildContext context, String title, String deskripsi) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                deskripsi,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Tutup',
                        style: TextStyle(color: Colors.orange)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
