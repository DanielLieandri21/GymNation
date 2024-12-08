import 'package:flutter/material.dart';
import 'package:gymnation/widget/facility_item_widget.dart';
import 'package:gymnation/api/DatagymAPI.dart';
import 'package:gymnation/login_screen/styles.dart';

class FacilityPage extends StatefulWidget {
  const FacilityPage({super.key});

  @override
  State<FacilityPage> createState() => _FacilityPageState();
}

class _FacilityPageState extends State<FacilityPage> {
  List<dynamic> _fasilitasList = [];
  bool _isLoading = true;
  final DatagymAPI datagymAPI = DatagymAPI();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final fasilitasData = await datagymAPI.fetchFasilitas();
      setState(() {
        _fasilitasList = fasilitasData;
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
            'Facilities',
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
                // Daftar Kelas
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _fasilitasList.isEmpty
                        ? const Center(
                            child: Text(
                              'Tidak ada data fasilitas.',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: _fasilitasList.length,
                              itemBuilder: (context, index) {
                                final fasilitas = _fasilitasList[index];
                                return FacilityItemWidget(
                                  title: fasilitas['title'],
                                  description: '',
                                  imageUrl: fasilitas['img_path'],
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
