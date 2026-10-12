import 'package:flutter/material.dart';
import '../store.dart';
import '../theme.dart';
import 'cart_page.dart';
import 'favorites_page.dart';
import 'home_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _store = AppStore.instance;

  final _pages = const [HomePage(), FavoritesPage(), OrdersPage(), ProfilePage()];
  final _titles = const ['Kantin Bu Sari', 'Favorit Saya', 'Riwayat Pesanan', 'Profil'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_titles[_index], style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              Badge(
                isLabelVisible: _store.cartCount > 0,
                label: Text('${_store.cartCount}'),
                offset: const Offset(-6, 6),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const CartPage())),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
          body: IndexedStack(index: _index, children: _pages),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            backgroundColor: Colors.white,
            indicatorColor: kPrimary.withOpacity(0.18),
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: kPrimary), label: 'Beranda'),
              NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite, color: kPrimary), label: 'Favorit'),
              NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long, color: kPrimary), label: 'Pesanan'),
              NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: kPrimary), label: 'Profil'),
            ],
          ),
        );
      },
    );
  }
}
