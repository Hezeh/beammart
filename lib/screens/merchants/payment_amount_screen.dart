import 'package:beammart/services/tokens_pricing.dart';
import 'package:beammart/utils/buy_with_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentAmountScreen extends StatefulWidget {
  final bool? card;
  final bool? mpesa;
  final bool? airtel;
  const PaymentAmountScreen({
    Key? key,
    this.card,
    this.mpesa,
    this.airtel,
  }) : super(key: key);

  @override
  _PaymentAmountScreenState createState() => _PaymentAmountScreenState();
}

class _PaymentAmountScreenState extends State<PaymentAmountScreen> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    String _paymentOption = "card";
    if (widget.card != null) {
      if (widget.card == true) {
        _paymentOption = "card";
      }
    } else {
      _paymentOption = "mobile_money";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Amount"),
      ),
      body: (!_loading)
          ? FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: tokensPricing(),
              builder: (BuildContext futureContext, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return LinearProgressIndicator();
                }
                return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (BuildContext buildContext, index) {
                      final _data = snapshot.data!.docs[index].data();
                      if (_data != null) {
                        return ListTile(
                          title: Text("${_data['tokens']} Tokens"),
                          subtitle: Text("Amount Due: Ksh. ${_data['amount']}"),
                          trailing: ElevatedButton(
                            child: Text("Buy"),
                            onPressed: () {
                              setState(() {
                                _loading = true;
                              });
                              buyWithCard(context, _data['amount'].toDouble())
                                  .then((value) {
                                Navigator.of(context, rootNavigator: true).pop();
                              });
                            },
                          ),
                        );
                      } else {
                        return Container(
                          child: Text("Sorry. An error occurred!"),
                        );
                      }
                    });
              })
          : Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
              ),
            ),
    );
  }
}
