import 'package:flutter/material.dart';
import '../store.dart';
import '../theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _edit(BuildContext context) {
    final store = AppStore.instance;
    final name = TextEditingController(text: store.userName);
    final phone = TextEditingController(text: store.userPhone);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ubah Profil',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            TextField(
                controller: name,
                decoration: const InputDecoration(
                    labelText: 'Nama', prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 10),
            TextField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'No. HP', prefixIcon: Icon(Icons.phone))),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (name.text.trim().isEmpty) return;
                store.updateProfile(name.text.trim(), phone.text.trim());
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: kPrimary,
                      child: Icon(Icons.person, size: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(store.userName,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(store.userPhone, style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.edit, color: kPrimary),
                        onPressed: () => _edit(context)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _stat('Pesanan', '${store.orders.length}', Icons.receipt_long),
                _stat('Favorit', '${store.favorites.length}', Icons.favorite),
                _stat('Keranjang', '${store.cartCount}', Icons.shopping_cart),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_active_outlined),
                    title: const Text('Notifikasi pesanan'),
                    value: store.notifOn,
                    activeColor: kPrimary,
                    onChanged: store.setNotif,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.local_fire_department_outlined),
                    title: const Text('Preferensi pedas'),
                    subtitle: Slider(
                      value: store.spicyLevel,
                      min: 0,
                      max: 3,
                      divisions: 3,
                      activeColor: kPrimary,
                      onChanged: store.setSpicy,
                    ),
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('Tentang Kantin Bu Sari'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => showAboutDialog(
                      context: context,
                      applicationName: 'Kantin Bu Sari',
                      applicationVersion: '1.0.0',
                      applicationIcon: const Icon(Icons.restaurant, color: kPrimary, size: 36),
                      children: const [
                        Text('Aplikasi pemesanan makanan kantin kampus. Pesan lebih dulu, '
                            'ambil tanpa antre.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _stat(String label, String value, IconData icon) => Expanded(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(icon, color: kPrimary),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      );
}
