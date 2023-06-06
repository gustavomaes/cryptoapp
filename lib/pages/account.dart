import 'package:first_app/configs/app_settings.dart';
import 'package:first_app/repositories/account_repository.dart';
import 'package:first_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  updateBalance() async {
    final form = GlobalKey<FormState>();
    final inputController = TextEditingController();
    final account = context.read<AccountRepository>();

    AlertDialog dialog = AlertDialog(
      title: const Text("Update balance"),
      content: Form(
        key: form,
        child: TextFormField(
          controller: inputController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
          ],
          validator: (value) {
            if (value!.isEmpty) return 'Balance is required.';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("cancel"),
        ),
        TextButton(
            onPressed: () {
              if (form.currentState!.validate()) {
                account.setBalance(double.parse(inputController.text));
                Navigator.pop(context);
              }
            },
            child: Text('save')),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }

  @override
  Widget build(BuildContext context) {
    final account = context.watch<AccountRepository>();
    final locale = context.watch<AppSettings>().locale;
    NumberFormat formatCurrency =
        NumberFormat.currency(locale: locale['locale'], name: locale['name']);

    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            ListTile(
              title: const Text("Balance"),
              subtitle: Text(
                formatCurrency.format(account.balance),
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.purple,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: updateBalance,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () => context.read<AuthService>().logout(),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Logout',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
