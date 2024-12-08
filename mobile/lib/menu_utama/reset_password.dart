import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gymnation/api/userAPI.dart';
import 'package:gymnation/widget/custom_textfield.dart';
import 'package:permission_handler/permission_handler.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController emailController = TextEditingController();
  final UserAPI userapi = UserAPI();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool mailIsEror = false;
  String emailErrorMessage = '';
  int countdownTime = 0;
  bool isButtonDisabled = false;
  bool isLoading = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool cekEmail(String email) {
    return (email.isNotEmpty);
  }

  void _requestResetPass(String email) async {
    setState(() {
      emailErrorMessage = '';
      mailIsEror = false;
      isLoading = true;
    });

    if (!cekEmail(email)) {
      setState(() {
        emailErrorMessage = 'email tidak boleh kosong';
        mailIsEror = false;
        isLoading = false;
      });
      return;
    }

    var response = await userapi.forgetPassword(email: email);
    setState(() {
      isLoading = false;
    });
    if (response) {
      String title = "Link reset password telah dikirim";
      String massage = "Silahkan cek email anda";
      showNotification(title, massage);
      startCountdown();
    } else {
      setState(() {
        emailErrorMessage = 'email tidak tidak ditemukan';
        mailIsEror = false;
        isLoading = false;
      });
    }
  }

  void _testing(String email) async {
    setState(() {
      emailErrorMessage = '';
      mailIsEror = false;
      isLoading = true;
    });

    if (!cekEmail(email)) {
      setState(() {
        emailErrorMessage = 'email tidak boleh kosong';
        mailIsEror = false;
        isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        isLoading = false;
      });

      String title = "Link reset password telah dikirim";
      String massage = "Silahkan cek email anda";
      final result = await userapi.forgetPassword(email: email);
      if (result) {
        showNotification(title, massage);
        startCountdown();
      } else {
        setState(() {
          emailErrorMessage = 'email tidak tidak ditemukan';
          mailIsEror = false;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        emailErrorMessage = 'email tidak tidak ditemukan';
        mailIsEror = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('terjadi kesalahan')),
      );
    }
  }

  void startCountdown() {
    setState(() {
      countdownTime = 60;
      isButtonDisabled = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        countdownTime--;
      });

      if (countdownTime <= 0) {
        timer.cancel();
        setState(() {
          isButtonDisabled = false;
        });
      }
    });
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
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
                  "Enter your email address to reset your password.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextfield(
                  isEror: mailIsEror,
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hint: 'Email',
                ),
                const SizedBox(height: 16),
                if (emailErrorMessage.isNotEmpty)
                  Text(
                    emailErrorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.orange,
                      )
                    : ElevatedButton(
                        onPressed: isButtonDisabled
                            ? null
                            : () {
                                String email = emailController.text;
                                // _requestResetPass(email);
                                _testing(email);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonDisabled
                              ? Colors.grey
                              : Colors.orange[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          child: Text(
                            isButtonDisabled
                                ? "Please wait ($countdownTime)"
                                : "Send",
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
