import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gymnation/api/meAPI.dart';
import 'package:gymnation/api/userAPI.dart';
import 'package:gymnation/config/database_helper.dart';
import 'package:gymnation/menu_utama/ubah_foto_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // TextEditingController untuk nama dan email
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final defaultIMG = 'assets/images/icon-appbar.jpg';
  final meAPI meapi = meAPI();
  final UserAPI userapi = UserAPI();
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
          _firstNameController.text = user[0][0]['first_name'];
          _firstNameController.text = user[0][0]['last_name'];
          _emailController.text = user[0][0]['email'];
          isLoading = false;
        });
      } else {
        final localUser = await dbHelper.getUser(7);
        if (localUser != null) {
          setState(() {
            user = localUser;
            isLoading = false;
          });
          print("Data user dari SQLite: $localUser");
        } else {
          if (!mounted) return;
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
      if (!mounted) return;
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/gymnation');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String masssage) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@mipmap/gymnation',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      masssage,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  Future<void> _updateProfileData() async {
    if (_emailController.text == user[0][0]['email'] &&
        _firstNameController.text == user[0][0]['first_name'] &&
        _lastNameController.text == user[0][0]['last_name']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil Anda adalah profil terbaru."),
        ),
      );
      return;
    }

    final success = await userapi.updateProfile(
      idUser: user[0][0]['id_user'],
      email: _emailController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
    );

    if (success) {
      String title = "Profile Update";
      String massage = "Profile anda berhasil diubah";
      showNotification(title, massage);
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal memperbarui profil."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Profile Page",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 255, 157, 0),
                  Color.fromARGB(255, 248, 145, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
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
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Foto Profil
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              user != null && user![0][0]['img_path'] != null
                                  ? NetworkImage(user![0][0]['img_path'])
                                  : const AssetImage(
                                          'assets/images/icon-appbar.jpg')
                                      as ImageProvider,
                          backgroundColor: Colors.grey.shade800,
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UbahFotoProfile(),
                              ),
                            );
                          },
                          child: const Text(
                            "Ubah Foto",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Input Nama Depan
                        TextField(
                          controller: _firstNameController,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 248, 145, 1),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.white,
                            ),
                            labelText: "Nama Depan",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Input Nama Belakang
                        TextField(
                          controller: _lastNameController,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 248, 145, 1),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.white,
                            ),
                            labelText: "Nama Belakang",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Input Email
                        TextField(
                          controller: _emailController,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 248, 145, 1),
                            filled: true,
                            prefixIcon: Icon(
                              Icons.person,
                              size: 20,
                              color: Colors.white,
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        ElevatedButton(
                          onPressed: () {
                            _updateProfileData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 248, 145, 1),
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                          ),
                          child: const Text(
                            "Simpan Perubahan",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ));
  }
}
