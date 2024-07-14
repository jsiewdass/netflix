import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class CustomBotomNavigation extends StatelessWidget {
  final int currentIndex;
  const CustomBotomNavigation({super.key, required this.currentIndex});
  void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFFE6111C),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Inicio'),
        BottomNavigationBarItem(
            icon: Icon(Icons.label_outline), label: 'Categorias'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline), label: 'Favoritos')
      ],
    );
  }
}
