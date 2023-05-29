import 'package:first_app/models/coin.dart';
import 'package:first_app/repositories/coin_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final coins = CoinRepository.coins;
  List<Coin> selectedCoins = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Coins'),
      ),
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
            title: Text(coins[index].name),
            trailing: Text(real.format(coins[index].price)),
            selected: selectedCoins.contains(coins[index]),
            selectedTileColor: Colors.deepPurple[50],
            onLongPress: () => setState(() {
              selectedCoins.contains(coins[index])
                  ? selectedCoins.remove(coins[index])
                  : selectedCoins.add(coins[index]);
            }),
          );
        },
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: coins.length,
      ),
    );
  }
}
