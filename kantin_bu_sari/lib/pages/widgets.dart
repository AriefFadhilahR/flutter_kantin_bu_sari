import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import 'detail_page.dart';

/// Kartu menu yang dipakai di beranda & favorit.
class MenuCard extends StatelessWidget {
  final MenuItem item;
  const MenuCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final fav = store.favorites.contains(item.id);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => DetailPage(item: item))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Hero(
                tag: 'menu-${item.id}',
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, size: 40, color: item.color),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(item.desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 15, color: Colors.amber),
                        Text(' ${item.rating}', style: const TextStyle(fontSize: 12)),
                        const Spacer(),
                        Text(rupiah(item.price),
                            style: const TextStyle(
                                color: kPrimary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    icon: Icon(fav ? Icons.favorite : Icons.favorite_border,
                        color: fav ? Colors.red : Colors.grey),
                    onPressed: () => store.toggleFav(item),
                  ),
                  IconButton.filled(
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(backgroundColor: kPrimary),
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {
                      store.add(item);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: Text('${item.name} ditambahkan ke keranjang'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
