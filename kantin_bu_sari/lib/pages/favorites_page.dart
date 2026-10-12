import 'package:flutter/material.dart';
import '../data.dart';
import '../store.dart';
import 'widgets.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final favs = kMenu.where((m) => store.favorites.contains(m.id)).toList();
        if (favs.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Belum ada menu favorit'),
                Text('Tekan ikon ♥ pada menu untuk menyimpan',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          );
        }
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Text('${favs.length} menu favorit',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            for (final m in favs)
              Dismissible(
                key: ValueKey('fav-${m.id}'),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => store.toggleFav(m),
                child: MenuCard(item: m),
              ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Geser ke kiri untuk menghapus dari favorit',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ],
        );
      },
    );
  }
}
