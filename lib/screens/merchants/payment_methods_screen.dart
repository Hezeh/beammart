import 'package:beammart/screens/merchants/payment_amount_screen.dart';
import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Payment"),
        ),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaymentAmountScreen(
                        card: true,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.payment_outlined,
                    size: 35,
                  ),
                  title: Text("Credit or Debit Card"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaymentAmountScreen(
                        mpesa: true,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.money_outlined,
                    size: 35,
                  ),
                  title: Text("Mpesa"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PaymentAmountScreen(
                        airtel: true,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: Icon(
                    Icons.money_outlined,
                    size: 35,
                  ),
                  title: Text("Airtel Money"),
                ),
              ),
            ),
          ],
        ));
  }
}
