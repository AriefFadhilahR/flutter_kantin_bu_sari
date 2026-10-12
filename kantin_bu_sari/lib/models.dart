import 'package:flutter/material.dart';

class MenuItem {
  final int id;
  final String name;
  final String desc;
  final int price;
  final String category; // Makanan, Minuman, Camilan
  final IconData icon;
  final Color color;
  final double rating;
  final bool isFavoriteDefault;

  const MenuItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.category,
    required this.icon,
    required this.color,
    required this.rating,
    this.isFavoriteDefault = false,
  });
}

class CartLine {
  final MenuItem item;
  int qty;
  String note;
  CartLine(this.item, {this.qty = 1, this.note = ''});
  int get subtotal => item.price * qty;
}

class OrderRecord {
  final String code;
  final DateTime time;
  final List<CartLine> lines;
  final int total;
  final String method;
  final String pickup;
  String status;
  OrderRecord({
    required this.code,
    required this.time,
    required this.lines,
    required this.total,
    required this.method,
    required this.pickup,
    this.status = 'Diproses',
  });
}
