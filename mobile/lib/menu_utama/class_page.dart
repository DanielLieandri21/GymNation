import 'package:flutter/material.dart';
import 'package:gymnation/api/DatagymAPI.dart';
import 'package:gymnation/login_screen/styles.dart';
import 'package:gymnation/widget/class_item_widget.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({super.key});

  @override
  State<ClassPage> createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  List<dynamic> _kelasList = [];
  bool _isLoading = true;
  final DatagymAPI datagymAPI = DatagymAPI();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final kelasData = await datagymAPI.fetchKelas();
      setState(() {
        _kelasList = kelasData;
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
            'Class',
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
              children: [
                const SizedBox(height: 20),
                // Daftar Kelas
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _kelasList.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada data makanan.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _kelasList.length,
                              itemBuilder: (context, index) {
                                final kelas = _kelasList[index];
                                // Pastikan Anda menampilkan item dengan benar
                                return ClassItem(
                                  title: kelas['nama_kelas']
                                      .toString(), // Gunakan data yang sesuai
                                  schedule: kelas['jadwal'].toString(),
                                  members: kelas['jumlah_anggota'].toString(),
                                  pelatih: kelas['pelatih'].toString(),
                                  icon: Icons.fitness_center,
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
        ));
  }
}
