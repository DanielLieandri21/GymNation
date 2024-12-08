import 'package:flutter/material.dart';
import 'package:gymnation/api/DatagymAPI.dart';
import 'package:gymnation/login_screen/styles.dart';
import 'package:gymnation/login_screen/styles.dart';
import 'package:gymnation/widget/discount_item.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  List<dynamic> _diskonList = [];
  bool _isLoading = true;
  final DatagymAPI datagymAPI = DatagymAPI();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final diskonData = await datagymAPI.fetchDiskon();
      setState(() {
        _diskonList = diskonData;
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
          'Discounts',
          style: TextStyles.title,
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // Ikon kembali
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      // Tambahkan Container dengan dekorasi gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade700, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Potongan Harga Terbaru',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .white, // Mengubah warna teks agar kontras dengan background gradient
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Nikmati potongan harga hingga 50% untuk produk pilihan setiap bulannya. Berikut adalah beberapa penawaran menarik:',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors
                      .white, // Mengubah warna teks agar kontras dengan background gradient
                ),
              ),
              const SizedBox(height: 16.0),
              // Daftar diskon
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _diskonList.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada data makanan.',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _diskonList.length,
                            itemBuilder: (context, index) {
                              final kelas = _diskonList[index];
                              // Pastikan Anda menampilkan item dengan benar
                              return DiscountItem(
                                title: kelas['title'].toString(),
                                discount: kelas['jumlah_diskon'].toString(),
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
