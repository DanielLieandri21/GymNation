import 'package:flutter/material.dart';
import 'package:gymnation/menu_utama/home_page_content.dart';
import 'package:gymnation/menu_utama/notification_page.dart';
import 'package:gymnation/menu_utama/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isSearching = false; // Variabel untuk menandai pencarian
  String _searchQuery = ""; // Variabel untuk menyimpan query pencarian

  // Method untuk memperbarui status pencarian
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching; // Toggle pencarian
      if (!_isSearching)
        _searchQuery = ""; // Reset query jika pencarian dimatikan
    });
  }

  // Method untuk memperbarui query pencarian
  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query; // Update search query
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade700, Colors.grey.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Background Scaffold dibuat transparan
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          toolbarHeight: 80.0,
          title: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Image.asset(
                    'assets/images/icon-appbar.jpg',
                    fit: BoxFit.contain, // Sesuaikan ukuran gambar
                  ),
                ),
              ),
              const Spacer(), // Mengisi ruang kosong di kanan
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationPage(),
                  ),
                );
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex, // Mengatur halaman yang akan ditampilkan
          children: [
            HomePageContent(
              isSearching: _isSearching,
              searchQuery: _searchQuery,
              onSearchQueryChanged: _updateSearchQuery,
            ),
            AccountPage(
              isSearching: _isSearching,
              searchQuery: _searchQuery,
              onSearchQueryChanged: _updateSearchQuery,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: _toggleSearch,
          child: const Icon(
            Icons.qr_code_scanner,
            size: 45,
            color: Colors.black,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8.0,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  // Tambahkan Spacer di kiri untuk penyeimbang
                  const Spacer(flex: 1),
                  IconButton(
                    icon: Icon(Icons.home,
                        color:
                            _selectedIndex == 0 ? Colors.orange : Colors.white),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 0; // Ubah ke halaman Home
                      });
                    },
                  ),
                  const SizedBox(width: 200), // Jarak antar icon
                  IconButton(
                    icon: Icon(Icons.account_circle,
                        color:
                            _selectedIndex == 1 ? Colors.orange : Colors.white),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 1; // Ubah ke halaman Account
                      });
                    },
                  ),
                  // Tambahkan Spacer di kanan untuk penyeimbang
                  const Spacer(
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
