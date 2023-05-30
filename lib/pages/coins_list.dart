import 'package:first_app/models/coin.dart';
import 'package:first_app/pages/coin_details.dart';
import 'package:first_app/repositories/coin_repository.dart';
import 'package:first_app/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinsList extends StatefulWidget {
  const CoinsList({super.key});

  @override
  State<CoinsList> createState() => _CoinsListState();
}

class _CoinsListState extends State<CoinsList> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final coins = CoinRepository.coins;
  List<Coin> selectedCoins = [];
  late FavoriteRepository favorites;

  customAppBar() {
    return selectedCoins.isEmpty
        ? AppBar(
            title: const Text('Crypto Coins'),
          )
        : AppBar(
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  selectedCoins = [];
                });
              },
            ),
            title: Text(
              "${selectedCoins.length} selected",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            backgroundColor: Colors.deepPurple[50],
            elevation: 1,
            iconTheme: const IconThemeData(color: Colors.black87),
          );
  }

  navigateToDetails(Coin coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinDetails(coin: coin),
      ),
    );
  }

  cleanSelectedCoins() {
    setState(() {
      selectedCoins = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    favorites = context.watch<FavoriteRepository>();

    return Scaffold(
      appBar: customAppBar(),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            leading: (selectedCoins.contains(coins[index]))
                ? const CircleAvatar(
                    child: Icon(Icons.check),
                  )
                : SizedBox(
                    width: 40,
                    child: Image.asset(coins[index].icon),
                  ),
            title: Row(
              children: [
                Text(coins[index].name),
                if (favorites.list.contains(coins[index]))
                  const Icon(
                    Icons.circle,
                    color: Colors.red,
                    size: 8,
                  )
              ],
            ),
            trailing: Text(real.format(coins[index].price)),
            selected: selectedCoins.contains(coins[index]),
            selectedTileColor: Colors.deepPurple[50],
            onLongPress: () => setState(() {
              selectedCoins.contains(coins[index])
                  ? selectedCoins.remove(coins[index])
                  : selectedCoins.add(coins[index]);
            }),
            onTap: () => navigateToDetails(coins[index]),
          );
        },
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: coins.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: (selectedCoins.isNotEmpty)
          ? FloatingActionButton.extended(
              onPressed: () {
                favorites.saveAll(selectedCoins);
                cleanSelectedCoins();
              },
              icon: const Icon(Icons.star),
              label: const Text(
                "Favorite",
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
