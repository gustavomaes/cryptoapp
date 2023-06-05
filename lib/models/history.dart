import 'package:first_app/models/coin.dart';

class History {
  DateTime date;
  String type;
  Coin coin;
  double price;
  double amount;

  History({
    required this.date,
    required this.type,
    required this.coin,
    required this.price,
    required this.amount,
  });
}