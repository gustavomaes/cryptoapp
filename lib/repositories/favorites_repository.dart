import 'dart:collection';

import 'package:first_app/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../adapters/coin_hive_adapter.dart';

class FavoriteRepository extends ChangeNotifier {
  final List<Coin> _list = [];
  late LazyBox box;

  FavoriteRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavorites();
  }

  _openBox() async {
    Hive.registerAdapter(CoinHiveAdapter());
    box = await Hive.openLazyBox<Coin>('favorites_coins');
  }

  _readFavorites() async {
    box.keys.forEach((coin) async {
      Coin c = await box.get(coin);
      _list.add(c);
      notifyListeners();
    });
  }

  UnmodifiableListView<Coin> get list => UnmodifiableListView(_list);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_list.any((element) => element.acronym == coin.acronym)) {
        _list.add(coin);
        box.put(coin.acronym, coin);
      }
    });
    notifyListeners();
  }

  remove(Coin coin) {
    _list.remove(coin);
    box.delete(coin.acronym);
    notifyListeners();
  }
}
