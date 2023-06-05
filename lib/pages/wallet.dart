import 'package:first_app/configs/app_settings.dart';
import 'package:first_app/repositories/account_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/position.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  int index = 0;
  double totalWallet = 0;
  double balance = 0;
  late NumberFormat formatCurrency;
  late AccountRepository account;

  String graphLabel = '';
  double graphValue = 0;
  List<Position> wallet = [];

  @override
  Widget build(BuildContext context) {
    account = context.watch<AccountRepository>();
    final locale = context.read<AppSettings>().locale;
    formatCurrency =
        NumberFormat.currency(locale: locale['locale'], name: locale['name']);

    setTotalWallet();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                'Wallet balance',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              formatCurrency.format(totalWallet),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.5,
              ),
            ),
            loadGraph(),
          ],
        ),
      ),
    );
  }

  setTotalWallet() {
    final walletList = account.wallet;

    setState(() {
      totalWallet = account.balance;
      for (var position in walletList) {
        totalWallet += position.coin.price * position.amount;
      }
    });
  }

  setGraphDate(int index) {
    if (index < 0) return;

    if (index == wallet.length) {
      graphLabel = 'Balance';
      graphValue = account.balance;
    } else {
      graphLabel = wallet[index].coin.name;
      graphValue = wallet[index].coin.price * wallet[index].amount;
    }
  }

  loadWallet() {
    setGraphDate(index);
    wallet = account.wallet;
    final listSize = wallet.length + 1;

    return List.generate(listSize, (i) {
      final isTouched = i == index;
      final isBalance = i == listSize - 1;
      final fontSize = isTouched ? 18.00 : 14.00;
      final radius = isTouched ? 60.00 : 50.00;
      final color = isTouched ? Colors.purple : Colors.purple[400];

      double percentage = 0;
      if (!isBalance) {
        percentage = wallet[i].coin.price * wallet[i].amount / totalWallet;
      } else {
        percentage = (account.balance > 0) ? account.balance / totalWallet : 0;
      }

      percentage *= 100;

      return PieChartSectionData(
        color: color,
        value: percentage,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    });
  }

  loadGraph() {
    return totalWallet <= 0
        ? Container(
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(PieChartData(
                  sectionsSpace: 5,
                  centerSpaceRadius: 110,
                  sections: loadWallet(),
                  pieTouchData: PieTouchData(
                    touchCallback: (_, touch) => setState(() {
                      index = touch!.touchedSection!.touchedSectionIndex;
                      setGraphDate(index);
                    }),
                  ),
                )),
              ),
              Column(
                children: [
                  Text(
                    graphLabel,
                    style: TextStyle(fontSize: 20, color: Colors.purple),
                  ),
                  Text(
                    formatCurrency.format(graphValue),
                    style: TextStyle(fontSize: 28),
                  ),
                ],
              ),
            ],
          );
  }
}
