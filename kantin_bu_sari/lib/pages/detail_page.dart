import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';

class DetailPage extends StatefulWidget {
  final MenuItem item;
  const DetailPage({super.key, required this.item});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _store = AppStore.instance;
  final _note = TextEditingController();
  int _qty = 1;
  String _size = 'Reguler';
  bool _extraSambal = false;
  double _spicy = 2;

  MenuItem get item => widget.item;
  bool get _isFood => item.category == 'Makanan' || item.category == 'Camilan';
  int get _unit => item.price + (_size == 'Jumbo' ? 3000 : 0) + (_extraSambal ? 1000 : 0);

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final fav = _store.favorites.contains(item.id);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Menu'),
            actions: [
              IconButton(
                icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                onPressed: () => _store.toggleFav(item),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // 1) Hero ikon
              Hero(
                tag: 'menu-${item.id}',
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(item.icon, size: 96, color: item.color),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(item.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  Text(rupiah(item.price),
                      style: const TextStyle(fontSize: 18, color: kPrimary, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  Chip(
                      avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                      label: Text('${item.rating}')),
                  Chip(label: Text(item.category)),
                  const Chip(
                      avatar: Icon(Icons.timer_outlined, size: 16), label: Text('± 10 menit')),
                ],
              ),
              const SizedBox(height: 8),
              Text(item.desc, style: TextStyle(color: Colors.grey.shade700, height: 1.4)),
              const Divider(height: 28),
              // 2) Ukuran: RadioListTile
              const Text('Ukuran porsi', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioGroup<String>(
                groupValue: _size,
                onChanged: (v) => setState(() => _size = v!),
                child: Column(
                  children: const [
                    RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Reguler'),
                        value: 'Reguler'),
                    RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Jumbo (+Rp 3.000)'),
                        value: 'Jumbo'),
                  ],
                ),
              ),
              // 3) Tambahan: SwitchListTile
              if (_isFood) ...[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Tambah sambal (+Rp 1.000)'),
                  value: _extraSambal,
                  activeColor: kPrimary,
                  onChanged: (v) => setState(() => _extraSambal = v),
                ),
                // 4) Tingkat pedas: Slider
                Text('Tingkat pedas: ${['Tidak pedas', 'Sedang', 'Pedas', 'Level dewa'][_spicy.round()]}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: _spicy,
                  min: 0,
                  max: 3,
                  divisions: 3,
                  activeColor: kPrimary,
                  onChanged: (v) => setState(() => _spicy = v),
                ),
              ],
              // 5) Catatan: TextField
              TextField(
                controller: _note,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan untuk penjual',
                  hintText: 'Contoh: tanpa bawang goreng',
                  prefixIcon: Icon(Icons.edit_note),
                ),
              ),
              const SizedBox(height: 90),
            ],
          ),
          bottomSheet: Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 8),
            ]),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // 6) Stepper jumlah
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
                        ),
                        Text('$_qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(() => _qty++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final extras = <String>[
                          if (_size == 'Jumbo') 'Jumbo',
                          if (_extraSambal) 'Extra sambal',
                          if (_isFood) 'Pedas ${_spicy.round()}/3',
                          if (_note.text.trim().isNotEmpty) _note.text.trim(),
                        ].join(' • ');
                        final custom = MenuItem(
                          id: item.id,
                          name: item.name,
                          desc: item.desc,
                          price: _unit,
                          category: item.category,
                          icon: item.icon,
                          color: item.color,
                          rating: item.rating,
                        );
                        _store.add(custom, qty: _qty, note: extras);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('$_qty × ${item.name} masuk keranjang'),
                          behavior: SnackBarBehavior.floating,
                        ));
                      },
                      child: Text('Tambah • ${rupiah(_unit * _qty)}'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
