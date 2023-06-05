import 'package:first_app/database/db.dart';
import 'package:first_app/models/coin.dart';
import 'package:first_app/models/position.dart';
import 'package:first_app/repositories/coin_repository.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;
  List<Position> _wallet = [];
  double _balance = 0;

  get balance => _balance;
  List<Position> get wallet => _wallet;

  AccountRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getBalance();
    await _getWallet();
  }

  _getBalance() async {
    db = await DB.instance.database;
    List account = await db.query('account', limit: 1);
    _balance = account.first['balance'];
    notifyListeners();
  }

  setBalance(double value) async {
    db = await DB.instance.database;
    db.update('account', {'balance': value});
    _balance = value;
    notifyListeners();
  }

  buy(Coin coin, double value) async {
    db = await DB.instance.database;

    await db.transaction((txn) async {
      final coinPosition = await txn
          .query('wallet', where: 'acronym = ?', whereArgs: [coin.acronym]);

      if (coinPosition.isEmpty) {
        await txn.insert('wallet', {
          'acronym': coin.acronym,
          'coin': coin.name,
          'amount': (value / coin.price).toString(),
        });
      } else {
        final currentPosition =
            double.parse(coinPosition.first['amount'].toString());
        await txn.update(
          'wallet',
          {'amount': (currentPosition + (value / coin.price)).toString()},
          where: 'acronym = ?',
          whereArgs: [coin.acronym],
        );
      }

      await txn.insert('history', {
        'acronym': coin.acronym,
        'coin': coin.name,
        'amount': (value / coin.price).toString(),
        'price': value,
        'type': 'buy',
        'date': DateTime.now().millisecondsSinceEpoch,
      });

      await txn.update('account', {'balance': balance - value});
    });
    await _initRepository();
    notifyListeners();
  }

  _getWallet() async {
    _wallet = [];
    List positions = await db.query('wallet');
    positions.forEach((position) {
      Coin coin = CoinRepository.coins
          .firstWhere((c) => c.acronym == position['acronym']);
      _wallet.add(Position(coin: coin, amount: double.parse(position['amount'])));
    });
    notifyListeners();
  }
}
