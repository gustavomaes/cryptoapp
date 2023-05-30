import 'package:first_app/pages/coins_list.dart';
import 'package:first_app/pages/favorites.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPage = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: currentPage);
  }

  setCurrentPage(page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: setCurrentPage,
        children: const [
          CoinsList(),
          Favorites(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Coins'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
        onTap: (page) {
          pc.animateToPage(page, duration: const Duration(milliseconds: 400), curve: Curves.ease);
        },
      ),
    );
  }
}