import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymnation/menu_utama/home_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymnation/api/meAPI.dart';
import 'package:gymnation/api/userAPI.dart';
import 'package:permission_handler/permission_handler.dart';

class UbahFotoProfile extends StatefulWidget {
  const UbahFotoProfile({super.key});

  @override
  State<UbahFotoProfile> createState() => _UbahFotoProfileState();
}

class _UbahFotoProfileState extends State<UbahFotoProfile> {
  final meAPI meapi = meAPI();
  final UserAPI userapi = UserAPI();
  var user;
  bool isLoading = true;
  bool isUploading = false;
  File? selectedImage;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  Future<void> initUser() async {
    try {
      var response = await meapi.getUserProfile();
      if (response['status'] == true && response['data'] != null) {
        setState(() {
          user = response['data'];
          isLoading = false;
        });
      } else {
        print("Failed to retrieve user data: ${response['message']}");
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

  Future<void> pickImage(ImageSource source) async {
    if (source == ImageSource.camera &&
        !(await Permission.camera.request().isGranted)) {
      openAppSettings();
      print("Camera permission denied");
      return;
    }

    if (source == ImageSource.gallery &&
        !(await Permission.photos.request().isGranted)) {
      openAppSettings();
      print("Photo library permission denied");
      return;
    }

    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _updateProfileData(File selectedImage, int idUser) async {
    setState(() {
      isUploading = true;
    });
    try {
      var response = await userapi.changeProfilePict(
          profile_pict: selectedImage, id_user: idUser);

      print("Format gambar $selectedImage");
      if (response) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto profil berhasil diperbarui!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui foto: ${response}')),
        );
      }
    } catch (e) {
      print("Error updating profile picture: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan saat mengunggah foto.')),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Ubah Foto Profile",
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
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange, // Warna indikator
                  ),
                ))
              : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade700, Colors.grey.shade900],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Foto Profil
                      CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[400],
                        backgroundImage: selectedImage != null
                            ? FileImage(
                                selectedImage!,
                              )
                            : (user != null && user[0][0]['img_path'] != null
                                ? NetworkImage(user[0][0]['img_path'])
                                    as ImageProvider
                                : const AssetImage(
                                    'assets/images/icon-appbar.jpg')),
                      ),
                      const SizedBox(height: 24),

                      // Tombol Pilih Sumber Gambar
                      ElevatedButton.icon(
                        onPressed: showImageSourceDialog,
                        icon: const Icon(Icons.image),
                        label: const Text("Pilih Gambar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Tombol Kirim
                      ElevatedButton(
                        onPressed: selectedImage != null && !isUploading
                            ? () => _updateProfileData(
                                  selectedImage!,
                                  user[0][0]['id_user'],
                                )
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 24),
                          child: isUploading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                )
                              : const Text(
                                  "Kirim",
                                  style: TextStyle(
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
        ));
  }
}
