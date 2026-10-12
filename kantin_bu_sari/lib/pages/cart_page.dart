import 'package:flutter/material.dart';
import '../data.dart';
import '../models.dart';
import '../store.dart';
import '../theme.dart';
import 'success_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _store = AppStore.instance;
  String _method = 'QRIS';
  String _pickup = kPickupSlots.first;
  bool _useVoucher = false;

  int get _discount => _useVoucher ? (_store.cartTotal * 10 ~/ 100) : 0;
  int get _grand => _store.cartTotal - _discount;

  Future<void> _confirm() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Pesanan'),
        content: Text('Total ${rupiah(_grand)} via $_method.\nAmbil: $_pickup.\n\nLanjutkan pesanan?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kPrimary),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Ya, pesan')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final rec = _store.checkout(method: _method, pickup: _pickup);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => SuccessPage(order: rec, paid: _grand)));
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Keranjang')),
          body: _store.cart.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_cart_outlined, size: 72, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Keranjang masih kosong'),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final line in List<CartLine>.from(_store.cart))
                      Dismissible(
                        key: ObjectKey(line),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                              color: Colors.red.shade400, borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _store.remove(line),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: line.item.color.withOpacity(0.15),
                              child: Icon(line.item.icon, color: line.item.color),
                            ),
                            title: Text(line.item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              '${rupiah(line.item.price)}${line.note.isEmpty ? '' : '\n${line.note}'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            isThreeLine: line.note.isNotEmpty,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () => _store.changeQty(line, -1)),
                                Text('${line.qty}',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                    visualDensity: VisualDensity.compact,
                                    icon: const Icon(Icons.add_circle, color: kPrimary),
                                    onPressed: () => _store.changeQty(line, 1)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    // Dropdown waktu ambil
                    DropdownButtonFormField<String>(
                      value: _pickup,
                      decoration: const InputDecoration(
                          labelText: 'Waktu pengambilan', prefixIcon: Icon(Icons.schedule)),
                      items: kPickupSlots
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => _pickup = v!),
                    ),
                    const SizedBox(height: 14),
                    const Text('Metode pembayaran',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    // Segmented / Choice metode bayar
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final m in ['QRIS', 'Tunai', 'Transfer'])
                          ChoiceChip(
                            label: Text(m),
                            selected: _method == m,
                            selectedColor: kPrimary,
                            labelStyle:
                                TextStyle(color: _method == m ? Colors.white : Colors.black87),
                            onSelected: (_) => setState(() => _method = m),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: kPrimary,
                      title: const Text('Pakai voucher HEMAT10 (diskon 10%)'),
                      value: _useVoucher,
                      onChanged: (v) => setState(() => _useVoucher = v!),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            _row('Subtotal', rupiah(_store.cartTotal)),
                            _row('Diskon', '- ${rupiah(_discount)}'),
                            const Divider(),
                            _row('Total', rupiah(_grand), bold: true),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _confirm,
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Pesan Sekarang'),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _row(String a, String b, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(a, style: TextStyle(fontWeight: bold ? FontWeight.bold : null)),
            Text(b,
                style: TextStyle(
                    fontWeight: bold ? FontWeight.bold : null,
                    color: bold ? kPrimary : null,
                    fontSize: bold ? 17 : null)),
          ],
        ),
      );
}
