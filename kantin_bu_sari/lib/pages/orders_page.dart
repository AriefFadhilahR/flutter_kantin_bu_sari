import 'package:flutter/material.dart';
import '../store.dart';
import '../theme.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  String _fmt(DateTime t) =>
      '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}/${t.year} '
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        if (store.orders.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 8),
                Text('Belum ada riwayat pesanan'),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: store.orders.length,
          itemBuilder: (_, i) {
            final o = store.orders[i];
            final done = o.status == 'Selesai';
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                shape: const Border(),
                leading: CircleAvatar(
                  backgroundColor: (done ? kGreen : kPrimary).withOpacity(0.15),
                  child: Icon(done ? Icons.check : Icons.hourglass_bottom,
                      color: done ? kGreen : kPrimary),
                ),
                title: Text(o.code, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${_fmt(o.time)} • ${o.status}'),
                trailing: Text(rupiah(o.total),
                    style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                children: [
                  for (final l in o.lines)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          Expanded(child: Text('${l.qty}× ${l.item.name}')),
                          Text(rupiah(l.subtotal)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Ambil: ${o.pickup} • Bayar: ${o.method}',
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                  if (!done)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          o.status = 'Selesai';
                          store.refresh();
                        },
                        icon: const Icon(Icons.done_all),
                        label: const Text('Tandai sudah diambil'),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
