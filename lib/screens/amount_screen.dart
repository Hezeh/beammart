import 'package:beammart/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AmountScreen extends StatefulWidget {
  @override
  _AmountScreenState createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  final TextEditingController _amountController = TextEditingController();
  final _amountFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Amount'),
        ),
        body: Form(
          key: _amountFormKey,
          child: ListView(
            children: [
              // A Form Field with amount
              Container(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _amountController,
                  autocorrect: true,
                  enableSuggestions: true,
                  maxLines: 3,
                  keyboardType: TextInputType.number,
                  cursorHeight: 50,
                  cursorColor: Colors.pink,
                  cursorWidth: 2,
                  autofocus: false,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              // Pay Button
              Container(
                margin: EdgeInsets.all(15),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate form
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Home(),
                      ),
                    );
                  },
                  child: Text(
                    'PAY',
                    style: GoogleFonts.gelasio(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
