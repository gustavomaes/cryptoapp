import 'package:first_app/configs/app_settings.dart';
import 'package:first_app/repositories/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    account = context.watch<AccountRepository>();
    final locale = context.read<AppSettings>().locale;
    formatCurrency =
        NumberFormat.currency(locale: locale['locale'], name: locale['name']);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                'Wallet balance',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Text(
              formatCurrency.format(totalWallet),
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: -1.5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
