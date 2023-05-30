import 'package:first_app/models/coin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CoinDetails extends StatefulWidget {
  final Coin coin;
  const CoinDetails({super.key, required this.coin});

  @override
  State<CoinDetails> createState() => _CoinDetailsState();
}

class _CoinDetailsState extends State<CoinDetails> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _value = TextEditingController();
  double amount = 0;

  buy() {
    if (_form.currentState!.validate()) {
      // save
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('successful purchase'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    child: Image.asset(widget.coin.icon),
                  ),
                  Container(width: 10),
                  Text(
                    real.format(widget.coin.price),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            (amount > 0)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      alignment: Alignment.center,
                      child: Text(
                        '$amount ${widget.coin.acronym}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  )
                : Container(margin: const EdgeInsets.only(bottom: 24)),
            Form(
              key: _form,
              child: TextFormField(
                controller: _value,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Value",
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  suffix: Text(
                    'dollars',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Value is required.';
                  } else if (double.parse(value) < 50) {
                    return 'Min value is U\$50.00';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    amount = value.isEmpty
                        ? 0
                        : double.parse(value) / widget.coin.price;
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: buy,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Buy',
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
