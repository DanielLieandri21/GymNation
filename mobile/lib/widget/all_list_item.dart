import 'package:flutter/material.dart';

class ListItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget page;
  final Color backgroundColor; // Parameter untuk warna latar belakang
  final Color iconColor; // Parameter untuk warna ikon
  final Color titleColor; // Parameter untuk warna judul
  final Color subtitleColor; // Parameter untuk warna subtitle

  const ListItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.page,
    this.backgroundColor = Colors.white, // Warna latar belakang default
    this.iconColor = Colors.black, // Warna ikon default
    this.titleColor = Colors.black, // Warna judul default
    this.subtitleColor = Colors.black54, // Warna subtitle default
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: backgroundColor, // Mengatur warna latar belakang
      child: ListTile(
        leading: Icon(icon, size: 40, color: iconColor), // Mengatur warna ikon
        title: Text(title, style: TextStyle(color: titleColor)), // Mengatur warna judul
        subtitle: Text(subtitle, style: TextStyle(color: subtitleColor)), // Mengatur warna subtitle
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page), // Navigasi ke halaman yang sesuai
          );
        },
      ),
    );
  }
}
