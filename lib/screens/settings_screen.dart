import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finnote/providers/transaction_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            onTap: () async {
               try {
                 final dbService = ref.read(databaseServiceProvider);
                 final path = await dbService.exportToCSV();
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Berhasil diekspor ke: $path'), duration: const Duration(seconds: 4)),
                   );
                 }
               } catch (e) {
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: Text('Gagal mengekspor data: $e')),
                   );
                 }
               }
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
