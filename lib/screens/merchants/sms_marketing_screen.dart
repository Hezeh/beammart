import 'package:beammart/providers/subscriptions_provider.dart';
import 'package:beammart/screens/merchants/payments_subscriptions_screen.dart';
import 'package:beammart/screens/merchants/pick_contact_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SMSMarketingScreen extends StatefulWidget {
  const SMSMarketingScreen({Key? key}) : super(key: key);

  @override
  State<SMSMarketingScreen> createState() => _SMSMarketingScreenState();
}

class _SMSMarketingScreenState extends State<SMSMarketingScreen> {
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    final subsProvider = Provider.of<SubscriptionsProvider>(context);
    if (subsProvider.queryProductError == null) {
      stack.add(
        Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _messageController,
                  autocorrect: true,
                  enableSuggestions: true,
                  maxLines: 4,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                    labelText: 'Message',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: Text("Continue"),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PickContactListScreen(
                          message: _messageController.text,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    } else {
      stack.add(
        Center(
          child: Text(subsProvider.queryProductError!),
        ),
      );
    }
    if (subsProvider.purchasePending) {
      stack.add(
        Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: const ModalBarrier(
                dismissible: false,
                color: Colors.grey,
              ),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
    if (subsProvider.purchases.isEmpty) {
      return PaymentsSubscriptionsScreen();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("SMS Marketing"),
      ),
      body: Stack(
        children: stack,
      ),
    );
  }
}
