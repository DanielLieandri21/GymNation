import 'package:flutter/material.dart';
import 'package:gymnation/api/loginAPI.dart';
import 'package:gymnation/api/meAPI.dart';
import 'package:gymnation/api/userAPI.dart';
import 'package:gymnation/config/database_helper.dart';
import 'package:gymnation/menu_utama/profile_page.dart';
import 'package:gymnation/menu_utama/support_page.dart';
import 'package:gymnation/menu_utama/ubah_password.dart';
import 'package:gymnation/widget/account_widget.dart'; // Import widget terpisah
import 'package:gymnation/login_screen/login_screen.dart';

class AccountPage extends StatefulWidget {
  final bool isSearching;
  final String searchQuery;
  final ValueChanged<String> onSearchQueryChanged;

  const AccountPage({
    super.key,
    required this.isSearching,
    required this.searchQuery,
    required this.onSearchQueryChanged,
  });

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final meAPI meapi = meAPI();
  var user;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<void> initUser() async {
    final dbHelper = DatabaseHelper();
    try {
      var response = await meapi.getUserProfile();
      if (response['status'] == true && response['data'] != null) {
        setState(() {
          user = response['data'];
          isLoading = false;
        });
        final localUser =
            await dbHelper.getUser(response['data'][0][0]['id_user']);
        if (localUser == null) {
          await dbHelper.insertUser({
            'id_user': response['data'][0][0]['id_user'],
            'first_name': response['data'][0][0]['first_name'],
            'last_name': response['data'][0][0]['last_name'],
            'email': response['data'][0][0]['email'],
            'imgPath': response['data'][0][0]['img_path'],
          });
        } else {
          if (localUser['first_name'] != response['data'][0][0]['first_name'] ||
              localUser['last_name'] != response['data'][0][0]['last_name'] ||
              localUser['email'] != response['data'][0][0]['email'] ||
              localUser['imgPath'] != response['data'][0][0]['img_path']) {
            await dbHelper.updateUser({
              'id_user': response['data'][0][0]['id_user'],
              'first_name': response['data'][0][0]['first_name'],
              'last_name': response['data'][0][0]['last_name'],
              'email': response['data'][0][0]['email'],
              'img_path': response['data'][0][0]['img_path'],
            });
          }
        }
        setState(() {
          user = response['data'];
          isLoading = false;
        });
      } else {
        print("Failed to retrieve user data: ${response['message']}");
        final localUser = await dbHelper.getUser(7);
        if (localUser != null) {
          setState(() {
            user = localUser;
            isLoading = false;
          });
          print("Data user dari SQLite: $localUser");
        } else {
          setState(() {
            isLoading = false;
          });
          print("Tidak ada data user di SQLite.");
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });
      await initUser();
    }
  }

  void navigateToSupport() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SupportPage()),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });
      await initUser();
    }
  }

  void navigateToChangePassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UbahPassword()),
    );

    if (result == true) {
      setState(() {
        isLoading = true;
      });
      await initUser();
    }
  }

  Future<void> logout() async {
    bool result = await LoginAPI().logout();
    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Logout failed")),
      );
    }
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
        backgroundColor: Colors.transparent,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Indikator loading
            : Column(
                children: [
                  if (widget.isSearching)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        onChanged: widget.onSearchQueryChanged,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Cari Akun atau Pengaturan...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIcon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 157, 0),
                          Color.fromARGB(255, 248, 145, 1)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              user != null && user![0][0]['img_path'] != null
                                  ? NetworkImage(user![0][0]['img_path'])
                                  : const AssetImage(
                                          'assets/images/icon-appbar.jpg')
                                      as ImageProvider,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user != null
                                  ? user![0][0]['first_name'] +
                                          ' ' +
                                          user![0][0]['last_name'] ??
                                      'Nama Tidak Diketahui'
                                  : 'Loading...',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user != null
                                  ? user![0][0]['email'] ??
                                      'Email Tidak Diketahui'
                                  : '',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        MenuItemWidget(
                          icon: Icons.person,
                          title: 'View Profile',
                          onTap: () {
                            navigateToProfile();
                          },
                        ),
                        MenuItemWidget(
                          icon: Icons.settings,
                          title: 'Change Password',
                          onTap: () {
                            navigateToChangePassword();
                          },
                        ),
                        const Divider(),
                        MenuItemWidget(
                          icon: Icons.support_agent,
                          title: 'Support',
                          onTap: () {
                            navigateToSupport();
                          },
                        ),
                        const Divider(),
                        MenuItemWidget(
                          icon: Icons.logout,
                          title: 'Sign Out',
                          onTap: () {
                            logout();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
