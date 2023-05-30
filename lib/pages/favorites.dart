import 'package:first_app/repositories/favorites_repository.dart';
import 'package:first_app/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: Container(
        color: Colors.purple.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12),
        child: Consumer<FavoriteRepository>(
          builder: (context, favorites, child) {
            return favorites.list.isEmpty
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star),
                      SizedBox(width: 16),
                      Text('No favorites yet!'),
                    ],
                  )
                : ListView.builder(
                    itemCount: favorites.list.length,
                    itemBuilder: (_, index) {
                      return CoinCard(coin: favorites.list[index]);
                    },
                  );
          },
        ),
      ),
    );
  }
}
