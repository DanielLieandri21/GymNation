import 'package:gymnation/api/loginAPI.dart';
import 'package:gymnation/api/meAPI.dart';
import 'package:gymnation/menu_utama/reset_password.dart';
import 'package:gymnation/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gymnation/login_screen/styles.dart';
import 'package:gymnation/menu_utama/home_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailLoginController =
      TextEditingController(); // Controller untuk email login
  final emailRegisterController =
      TextEditingController(); // Controller untuk email register
  final passwordLoginController = TextEditingController();
  final passwordRegisterController = TextEditingController();
  final confirmPasswordController =
      TextEditingController(); // Controller untuk Confirm Password
  bool isObscureLoginPassword = true; // Untuk password login
  bool isObscureRegisterPassword = true; // Untuk password register
  bool isObscureConfirmPassword = true; // Untuk Confirm Password
  String emailErrorMessage = '';
  String passErrorMessage = '';
  bool mailIsEror = false;
  bool passIsEror = false;
  bool isLoading = false;
  final LoginAPI loginapi = LoginAPI();
  final meAPI meapi = meAPI();
  final ResgistLink = dotenv.env['WEB_URL'].toString();
  Uri? ResgistLinkURL;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    ResgistLinkURL = Uri.parse(ResgistLink);
  }

  bool cekEmailnPass(String email, String pass) {
    return (email.isNotEmpty && pass.isNotEmpty);
  }

  void _login(String email, String password) async {
    setState(() {
      emailErrorMessage = '';
      passErrorMessage = '';
      mailIsEror = false;
      passIsEror = false;
      isLoading = true;
    });

    if (!cekEmailnPass(email, password)) {
      emailErrorMessage = 'email boleh kosong';
      passErrorMessage = 'password tidak boleh kosong';
      mailIsEror = false;
      passIsEror = false;
      isLoading = false;
    }

    var response = await loginapi.login(email, password);
    if (response['status'] == true) {
      var user = await meapi.getUserProfile();

      if (user['status'] == true && user['data'] != null) {
        String role = user['data'][0][0]['role'];

        if (role == 'pelanggan') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      } else {
        setState(() {
          emailErrorMessage = "Username or password is incorrect";
          passErrorMessage = "Username or password is incorrect";

          mailIsEror = true;
          passIsEror = true;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        emailErrorMessage =
            response['massage'] ?? "Username or password is incorrect";
        passErrorMessage =
            response['massage'] ?? "Username or password is incorrect";

        mailIsEror = true;
        passIsEror = true;
        isLoading = false;
      });
    }
  }

  void testing() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> _launchSignUpUrl() async {
    if (ResgistLink != null) {
      await launchUrl(ResgistLinkURL!, mode: LaunchMode.externalApplication);
    } else {
      print('Could not launch $ResgistLinkURL');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset:
            false, // Mencegah konten naik saat keyboard muncul
        appBar: AppBar(
          //untuk judul paling atas
          title: Text(
            'Login',
            style: TextStyles.title,
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Container(
            width: MediaQuery.of(context).size.width, // Lebar layar penuh
            height: MediaQuery.of(context).size.height, // Tinggi layar penuh
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/background-image.png'), // Pastikan path gambar sudah benar
                fit:
                    BoxFit.cover, // Mengatur gambar agar memenuhi seluruh layar
              ),
            ),
            child: Stack(children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black
                            .withOpacity(0.6), // Warna atas (transparan)
                        Colors.black
                            .withOpacity(0.3), // Warna bawah (transparan)
                      ],
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                        'assets/images/login-image.png'), // untuk memasukkan gambar
                    const SizedBox(height: 24),
                    Text(
                      'Login', // buat sub judul
                      style: TextStyles.title.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 24),
                    // Fungsi memanggil custom teks field untuk login
                    CustomTextfield(
                      isEror: mailIsEror,
                      controller: emailLoginController,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hint: 'Email or Username',
                    ),
                    const SizedBox(height: 16),
                    if (emailErrorMessage.isNotEmpty)
                      Text(
                        emailErrorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextfield(
                      isEror: passIsEror,
                      controller: passwordLoginController,
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      hint: 'Password',
                      isObscure: isObscureLoginPassword, // Ubah sesuai field
                      hasSuffix: true,
                      onPressed: () {
                        setState(() {
                          isObscureLoginPassword =
                              !isObscureLoginPassword; // Toggle untuk Password Login
                        });
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (passErrorMessage.isNotEmpty)
                      Text(
                        passErrorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResetPassword()),
                        );
                      },
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyles.title.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    if (isLoading)
                      Center(
                        child: const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange, // Warna indikator
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          String email = emailLoginController.text.trim();
                          String pass = passwordLoginController.text.trim();
                          _login(email, pass);
                          // testing();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600], // background
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(5), // border radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Login',
                            style: TextStyles.title
                                .copyWith(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Text(
                      'Don\'t have an account ?',
                      style: TextStyles.title.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    GestureDetector(
                      onTap: () {
                        _launchSignUpUrl();
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyles.body
                            .copyWith(fontSize: 18, color: AppColors.orange),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ))
            ])));
  }
}
