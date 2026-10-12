import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import 'detail_page.dart';
import 'widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _store = AppStore.instance;
  final _search = TextEditingController();
  String _cat = 'Semua';
  bool _gridMode = false;
  final _promo = PageController(viewportFraction: 0.92);

  List<MenuItem> get _filtered => kMenu.where((m) {
        final okCat = _cat == 'Semua' || m.category == _cat;
        final okSearch = m.name.toLowerCase().contains(_search.text.toLowerCase());
        return okCat && okSearch;
      }).toList();

  @override
  void dispose() {
    _search.dispose();
    _promo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final items = _filtered;
        return CustomScrollView(
          slivers: [
            // 1) Sapaan + TextField pencarian
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                decoration: const BoxDecoration(
                  color: kPrimary,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Halo, ${_store.userName} 👋',
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                    const Text('Mau makan apa hari ini?',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Cari menu favoritmu...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _search.text.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => setState(_search.clear)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 2) Carousel promo (PageView)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 130,
                child: PageView(
                  controller: _promo,
                  padEnds: false,
                  children: const [
                    _PromoBanner(title: 'Paket Hemat Mahasiswa', sub: 'Nasi + Ayam + Es Teh cuma Rp 20.000', c1: Color(0xFF2E7D32), c2: Color(0xFF66BB6A), icon: Icons.school),
                    _PromoBanner(title: 'Happy Hour 14.00', sub: 'Diskon 20% semua minuman', c1: Color(0xFF1565C0), c2: Color(0xFF42A5F5), icon: Icons.local_drink),
                    _PromoBanner(title: 'Menu Baru!', sub: 'Coba Kopi Susu Kantin hari ini', c1: Color(0xFF6A1B9A), c2: Color(0xFFAB47BC), icon: Icons.coffee),
                  ],
                ),
              ),
            ),
            // 3) Chip kategori (ChoiceChip)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: kCategories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final c = kCategories[i];
                    return ChoiceChip(
                      label: Text(c),
                      selected: _cat == c,
                      selectedColor: kPrimary,
                      labelStyle: TextStyle(
                          color: _cat == c ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600),
                      onSelected: (_) => setState(() => _cat = c),
                    );
                  },
                ),
              ),
            ),
            // 4) Header + toggle list/grid (SegmentedButton)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Row(
                  children: [
                    Text('Menu (${items.length})',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    SegmentedButton<bool>(
                      showSelectedIcon: false,
                      style: const ButtonStyle(visualDensity: VisualDensity.compact),
                      segments: const [
                        ButtonSegment(value: false, icon: Icon(Icons.view_list)),
                        ButtonSegment(value: true, icon: Icon(Icons.grid_view)),
                      ],
                      selected: {_gridMode},
                      onSelectionChanged: (s) => setState(() => _gridMode = s.first),
                    ),
                  ],
                ),
              ),
            ),
            // 5) Daftar menu (ListView / GridView) dengan Card
            if (items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 56, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Menu tidak ditemukan'),
                    ],
                  ),
                ),
              )
            else if (_gridMode)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _GridTile(item: items[i]),
                ),
              )
            else
              SliverList.builder(
                itemCount: items.length,
                itemBuilder: (_, i) => MenuCard(item: items[i]),
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        );
      },
    );
  }
}

class _PromoBanner extends StatelessWidget {
  final String title, sub;
  final Color c1, c2;
  final IconData icon;
  const _PromoBanner(
      {required this.title, required this.sub, required this.c1, required this.c2, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 0, 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(colors: [c1, c2]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(sub, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          Icon(icon, size: 56, color: Colors.white.withOpacity(0.85)),
        ],
      ),
    );
  }
}

class _GridTile extends StatelessWidget {
  final MenuItem item;
  const _GridTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => DetailPage(item: item))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, size: 48, color: item.color),
                ),
              ),
              const SizedBox(height: 8),
              Text(item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(' ${item.rating}', style: const TextStyle(fontSize: 12)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(rupiah(item.price),
                        style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
                  ),
                  InkWell(
                    onTap: () {
                      store.add(item);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: Text('${item.name} ditambahkan'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 1),
                        ));
                    },
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: kPrimary,
                      child: Icon(Icons.add, size: 18, color: Colors.white),
                    ),
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
