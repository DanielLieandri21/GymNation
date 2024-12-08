import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gymnation/api/pengaduanAPI.dart';
import 'package:gymnation/login_screen/styles.dart';
import 'package:gymnation/widget/custom_textfield.dart';

class PengaduanPage extends StatefulWidget {
  const PengaduanPage({super.key});

  @override
  State<PengaduanPage> createState() => _PengaduanPageState();
}

class _PengaduanPageState extends State<PengaduanPage> {
  final emailController = TextEditingController();
  final namaController = TextEditingController();
  final noTelponController = TextEditingController();
  final pesanController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String errorMessage = '';
  bool isEror = false;
  bool isLoading = false;
  final PengaduanAPI pengaduanapi = PengaduanAPI();

  bool cekRequest(String email, String pesan, String noTelpon, String nama) {
    return (email.isNotEmpty &&
        pesan.isNotEmpty &&
        noTelpon.isNotEmpty &&
        nama.isNotEmpty);
  }

  void _addPengaduan(
      String email, String pesan, String noTelpon, String nama) async {
    setState(() {
      errorMessage = '';
      isEror = false;
      isLoading = true;
    });

    if (!cekRequest(email, pesan, noTelpon, nama)) {
      errorMessage = 'Harap isi semua inputan';
      isEror = true;
      isLoading = false;
    }

    var response = await pengaduanapi.addPengaduan(
        name: nama, email: email, no_telpon: noTelpon, pesan: pesan);

    if (response) {
      String title = "Keluhan anda telah dikirim";
      String massage = "Pesan anda sedan diproses oleh admin";
      Navigator.pop(context);
      showNotification(title, massage);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesan anda tidak terkirim')),
      );
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

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaduan Page',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
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
        height: double.infinity, // Pastikan Container mengisi seluruh layar
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade700, Colors.grey.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Membungkus dengan SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextfield(
                  isEror: isEror,
                  controller: namaController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hint: 'Nama',
                ),
                const SizedBox(height: 16),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                CustomTextfield(
                  isEror: isEror,
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hint: 'Email',
                ),
                const SizedBox(height: 16),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                CustomTextfield(
                  isEror: isEror,
                  controller: noTelponController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hint: 'Nomor Telpon',
                ),
                const SizedBox(height: 16),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 10),
                TextField(
                  controller: pesanController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Tulis pesan Anda...',
                    hintStyle: TextStyles.body,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: isEror ? Colors.red : AppColors.darkGrey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1,
                        color: isEror ? Colors.red : AppColors.darkGrey,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 24),
                if (isLoading)
                  Center(
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange,
                      ),
                    ),
                  )
                else
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        String nama = namaController.text;
                        String email = emailController.text;
                        String noTelpon = noTelponController.text;
                        String pesan = pesanController.text;

                        _addPengaduan(email, pesan, noTelpon, nama);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[600], // background
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(5), // border radius
                        ),
                        fixedSize: Size(200, 60),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Kirim',
                          style: TextStyles.title
                              .copyWith(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
