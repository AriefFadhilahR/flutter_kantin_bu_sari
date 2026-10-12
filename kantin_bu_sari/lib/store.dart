import 'package:flutter/material.dart';
import 'data.dart';
import 'models.dart';

/// State aplikasi sederhana (keranjang, favorit, riwayat pesanan, profil).
class AppStore extends ChangeNotifier {
  AppStore._() {
    for (final m in kMenu) {
      if (m.isFavoriteDefault) favorites.add(m.id);
    }
  }
  static final AppStore instance = AppStore._();

  final List<CartLine> cart = [];
  final Set<int> favorites = {};
  final List<OrderRecord> orders = [];

  String userName = 'Mahasiswa Pakuan';
  String userPhone = '0812-3456-7890';
  bool notifOn = true;
  bool darkHint = false;
  double spicyLevel = 2;

  int get cartCount => cart.fold(0, (a, b) => a + b.qty);
  int get cartTotal => cart.fold(0, (a, b) => a + b.subtotal);

  void add(MenuItem item, {int qty = 1, String note = ''}) {
    final i = cart.indexWhere((c) => c.item.id == item.id);
    if (i >= 0) {
      cart[i].qty += qty;
      if (note.isNotEmpty) cart[i].note = note;
    } else {
      cart.add(CartLine(item, qty: qty, note: note));
    }
    notifyListeners();
  }

  void changeQty(CartLine line, int delta) {
    line.qty += delta;
    if (line.qty <= 0) cart.remove(line);
    notifyListeners();
  }

  void remove(CartLine line) {
    cart.remove(line);
    notifyListeners();
  }

  void toggleFav(MenuItem item) {
    if (!favorites.add(item.id)) favorites.remove(item.id);
    notifyListeners();
  }

  OrderRecord checkout({required String method, required String pickup}) {
    final code = 'KBS-${(1000 + orders.length * 7 + 123)}';
    final rec = OrderRecord(
      code: code,
      time: DateTime.now(),
      lines: cart.map((c) => CartLine(c.item, qty: c.qty, note: c.note)).toList(),
      total: cartTotal,
      method: method,
      pickup: pickup,
    );
    orders.insert(0, rec);
    cart.clear();
    notifyListeners();
    return rec;
  }

  void updateProfile(String name, String phone) {
    userName = name;
    userPhone = phone;
    notifyListeners();
  }

  void refresh() => notifyListeners();

  void setNotif(bool v) {
    notifOn = v;
    notifyListeners();
  }

  void setSpicy(double v) {
    spicyLevel = v;
    notifyListeners();
  }
}
