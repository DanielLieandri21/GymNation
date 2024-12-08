import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gymnation/api/meAPI.dart';
import 'package:gymnation/api/userAPI.dart';
import 'package:gymnation/widget/custom_textfield.dart';

class UbahPassword extends StatefulWidget {
  const UbahPassword({super.key});

  @override
  State<UbahPassword> createState() => _UbahPasswordState();
}

class _UbahPasswordState extends State<UbahPassword> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final meAPI meapi = meAPI();
  final UserAPI userapi = UserAPI();
  bool isObscure = true;
  bool passIsEror = false;
  String passErrorMessage = '';
  bool isLoading = true;
  var user;

  @override
  void initState() {
    super.initState();
    initUser();
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

  Future<void> initUser() async {
    try {
      var response = await meapi.getUserProfile();
      if (response['status'] == true && response['data'] != null) {
        setState(() {
          user = response['data'];
        });
      } else {
        print("Failed to retrieve user data: ${response['message']}");
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _changePassword(String newPass, String confirmPass) async {
    if (newPass.isEmpty || confirmPass.isEmpty) {
      setState(() {
        passIsEror = true;
        passErrorMessage =
            'password dan konfirmasi password tidak boleh kosong';
      });
      return;
    }

    if (newPass != confirmPass) {
      setState(() {
        passIsEror = true;
        passErrorMessage = 'password dan konfirmasi password harus sesuai';
      });
      return;
    }

    final success = await userapi.changePassword(
      idUser: user[0][0]['id_user'],
      newPass: newPass,
    );
    print("response dari userapi $success");

    if (success) {
      String title = "Password Update";
      String massage = "Password anda telah diubah";
      showNotification(title, massage);
      Navigator.pop(context, true);
    } else {
      setState(() {
        passIsEror = true;
        passErrorMessage = 'gagal memperbarui password';
      });
    }
  }

  void testing(String newPass, String confirmPass) {
    if (newPass.isEmpty || confirmPass.isEmpty) {
      setState(() {
        passIsEror = true;
        passErrorMessage =
            'password dan konfirmasi password tidak boleh kosong';
      });
      return;
    }

    if (newPass != confirmPass) {
      setState(() {
        passIsEror = true;
        passErrorMessage = 'password dan konfirmasi password harus sesuai';
      });
      return;
    }
    String title = "Password Update";
    String massage = "Password anda telah diubah";
    showNotification(title, massage);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reset Password",
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Text(
                  "Enter your new password to change your password.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  isEror: passIsEror,
                  controller: passwordController,
                  textInputType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  hint: 'New Password',
                  isObscure: isObscure, // Ubah sesuai field
                  hasSuffix: true,
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure; // Toggle untuk Password Login
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (passErrorMessage.isNotEmpty)
                  Text(
                    passErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                CustomTextfield(
                  isEror: passIsEror,
                  controller: confirmPasswordController,
                  textInputType: TextInputType.visiblePassword,
                  textInputAction: TextInputAction.done,
                  hint: 'Confirm Password',
                  isObscure: isObscure, // Ubah sesuai field
                  hasSuffix: true,
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure; // Toggle untuk Password Login
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (passErrorMessage.isNotEmpty)
                  Text(
                    passErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String newPass = passwordController.text;
                    String confirmPass = confirmPasswordController.text;
                    // testing(newPass, confirmPass);
                    _changePassword(newPass, confirmPass);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                    child: Text(
                      "Send",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
