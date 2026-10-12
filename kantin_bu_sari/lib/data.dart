import 'package:flutter/material.dart';
import 'models.dart';

const List<String> kCategories = ['Semua', 'Makanan', 'Minuman', 'Camilan'];

const List<MenuItem> kMenu = [
  MenuItem(id: 1, name: 'Nasi Goreng Spesial', desc: 'Nasi goreng bumbu rempah dengan telur, ayam suwir, dan kerupuk.', price: 15000, category: 'Makanan', icon: Icons.rice_bowl, color: Color(0xFFEF6C00), rating: 4.8, isFavoriteDefault: true),
  MenuItem(id: 2, name: 'Ayam Geprek', desc: 'Ayam crispy dengan sambal bawang pedas, nasi putih, dan lalapan.', price: 17000, category: 'Makanan', icon: Icons.local_fire_department, color: Color(0xFFD84315), rating: 4.9),
  MenuItem(id: 3, name: 'Mie Ayam Bakso', desc: 'Mie kenyal, ayam kecap, bakso sapi, dan kuah kaldu hangat.', price: 14000, category: 'Makanan', icon: Icons.ramen_dining, color: Color(0xFF8D6E63), rating: 4.7),
  MenuItem(id: 4, name: 'Soto Ayam', desc: 'Soto kuning bening dengan suwiran ayam, soun, dan telur rebus.', price: 13000, category: 'Makanan', icon: Icons.soup_kitchen, color: Color(0xFFF9A825), rating: 4.6),
  MenuItem(id: 5, name: 'Es Teh Manis', desc: 'Teh seduh segar dengan es batu dan gula pilihan.', price: 4000, category: 'Minuman', icon: Icons.local_cafe, color: Color(0xFF6D4C41), rating: 4.5, isFavoriteDefault: true),
  MenuItem(id: 6, name: 'Es Jeruk Peras', desc: 'Jeruk peras asli, segar dan sedikit asam manis.', price: 6000, category: 'Minuman', icon: Icons.emoji_food_beverage, color: Color(0xFFFB8C00), rating: 4.6),
  MenuItem(id: 7, name: 'Kopi Susu Kantin', desc: 'Kopi susu gula aren khas kantin, cocok untuk teman belajar.', price: 9000, category: 'Minuman', icon: Icons.coffee, color: Color(0xFF4E342E), rating: 4.8),
  MenuItem(id: 8, name: 'Pisang Goreng', desc: 'Pisang kepok goreng tepung renyah, disajikan hangat.', price: 7000, category: 'Camilan', icon: Icons.bakery_dining, color: Color(0xFFFFB300), rating: 4.4),
  MenuItem(id: 9, name: 'Risoles Mayo', desc: 'Kulit tipis renyah isi sayur, ayam, dan saus mayo.', price: 5000, category: 'Camilan', icon: Icons.lunch_dining, color: Color(0xFFC62828), rating: 4.5),
  MenuItem(id: 10, name: 'Tahu Crispy', desc: 'Tahu goreng tepung gurih dengan bumbu tabur pedas.', price: 6000, category: 'Camilan', icon: Icons.fastfood, color: Color(0xFF7CB342), rating: 4.3),
];

const List<String> kPickupSlots = [
  'Istirahat 1 (10.00)',
  'Istirahat 2 (12.00)',
  'Istirahat 3 (14.30)',
];
