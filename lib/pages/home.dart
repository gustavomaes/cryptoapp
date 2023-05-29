import 'package:first_app/repositories/coin_repository.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final coins = CoinRepository.coins;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Coins'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.asset(coins[index].icon),
            title: Text(coins[index].name),
            trailing: Text(coins[index].price.toString()),
          );
        },
        padding: const EdgeInsets.all(12),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: coins.length,
      ),
    );
  }
}
