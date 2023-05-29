import 'package:first_app/models/coin.dart';

class CoinRepository {
  static List<Coin> coins = [
    Coin(icon: 'images/btc.png', name: 'Bitcoin', acronym: 'BTC', price: 204870.20),
    Coin(icon: 'images/eth.png', name: 'Ethereum', acronym: 'ETH', price: 1325.20),
    Coin(icon: 'images/xrp.png', name: 'XRP', acronym: 'XRP', price: 0.64),
    Coin(icon: 'images/ada.png', name: 'ADA', acronym: 'Cardano', price: 1234.64),
    Coin(icon: 'images/usdc.png', name: 'USD Coin', acronym: 'USDC', price: 100200.64),
  ];
}