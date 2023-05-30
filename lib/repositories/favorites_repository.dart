import 'dart:collection';

import 'package:first_app/models/coin.dart';
import 'package:flutter/material.dart';

class FavoriteRepository extends ChangeNotifier {
  final List<Coin> _list = [];

  UnmodifiableListView<Coin> get list  => UnmodifiableListView(_list);

  saveAll(List<Coin> coins) {
    coins.forEach((coin) {
      if (!_list.contains(coin)) _list.add(coin);
    });
    notifyListeners();
  }

  remove(Coin coin) {
    _list.remove(coin);
    notifyListeners();
  }
}