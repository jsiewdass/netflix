import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../views/views.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final int page;
  const HomeScreen({super.key, required this.page});
  final viewRoutes = const <Widget>[HomeView(), SizedBox(), FavoritesView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: page, children: viewRoutes),
      bottomNavigationBar: CustomBotomNavigation(currentIndex: page),
    );
  }
}
