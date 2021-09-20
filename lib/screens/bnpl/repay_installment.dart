import 'package:flutter/material.dart';

class RepayInfoScreen extends StatelessWidget {
  const RepayInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("How To Repay"),
      ),
      body: ListView(
        children: [
          // Steps
          Center(
            child: Text("Repay With Lipa Na M-Pesa"),
          ),
          StepWidget(
            stepNumber: 1,
            stepContent: "Go to the Lipa Na M-Pesa Menu",
          ),
          StepWidget(
            stepNumber: 2,
            stepContent: "Enter Paybill Number: 489900",
          ),
          StepWidget(
            stepNumber: 3,
            stepContent: "Account Number: Your Phone Number",
          ),
          StepWidget(
            stepNumber: 4,
            stepContent: "Enter Amount and Send",
          ),

          // Credit/Debit Card
          Center(
            child: Text("Repay With Debit/Credit Card"),
          )
        ],
      ),
    );
  }
}

class StepWidget extends StatelessWidget {
  final int? stepNumber;
  final String? stepContent;

  const StepWidget({
    Key? key,
    this.stepNumber,
    this.stepContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("$stepNumber"),
      title: Text("$stepContent"),
    );
  }
}
