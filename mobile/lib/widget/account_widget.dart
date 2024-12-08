import 'package:flutter/material.dart';

// Widget terpisah untuk menampilkan setiap item menu
class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? shortcut; // Tambahkan shortcut jika diperlukan
  final VoidCallback? onTap;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    this.shortcut, // Optional parameter for shortcut
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      trailing: shortcut != null // Hanya tampilkan trailing jika shortcut ada
          ? Text(
              shortcut!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            )
          : null,
      onTap: onTap,
    );
  }
}
