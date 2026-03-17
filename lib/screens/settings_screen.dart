import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Preferensi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Mata Uang'),
            subtitle: const Text('Rupiah (IDR)'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hanya IDR yang didukung saat ini.')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Tema Gelap'),
            trailing: Switch(
              value: false,
              onChanged: (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tema gelap akan segera hadir!')),
                );
              },
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Data', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Ekspor Data (CSV)'),
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur ekspor sedang dalam pengembangan.')),
              );
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Tentang', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Versi Aplikasi'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
