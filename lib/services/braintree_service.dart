import 'package:flutter_braintree/flutter_braintree.dart';

payWithBraintree() async {
  final request = BraintreeCreditCardRequest(
    cardNumber: '4111111111111111',
    expirationMonth: '12',
    expirationYear: '2021',
    cvv: '367',
  );

  BraintreePaymentMethodNonce? result = await Braintree.tokenizeCreditCard(
    '<Insert your tokenization key or client token here>',
    request,
  );
  print(result!.nonce);
}
