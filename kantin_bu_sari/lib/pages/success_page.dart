import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';

class SuccessPage extends StatelessWidget {
  final OrderRecord order;
  final int paid;
  const SuccessPage({super.key, required this.order, required this.paid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.elasticOut,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: const Icon(Icons.check_circle, size: 110, color: kGreen),
              ),
              const SizedBox(height: 12),
              const Text('Pesanan Berhasil!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Pesananmu sedang disiapkan Bu Sari 🍳'),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _r('Kode pesanan', order.code),
                      _r('Metode bayar', order.method),
                      _r('Ambil di', order.pickup),
                      _r('Jumlah item', '${order.lines.fold<int>(0, (a, b) => a + b.qty)}'),
                      const Divider(),
                      _r('Total dibayar', rupiah(paid), bold: true),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _r(String a, String b, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(a),
            Text(b, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
          ],
        ),
      );
}
