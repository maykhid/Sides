import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PayStackNotifier with ChangeNotifier {
  PaystackPlugin _paystackPlugin;

  PayStackNotifier.initialize(this._paystackPlugin) {
    _paystackPlugin.initialize(
      /// This public key is only here for test purposes
        publicKey: 'pk_test_c1cfac0c6cbf5a6c5432ccafb3815a274f912d4a');
  }

  Future<bool> checkOut(
      {BuildContext context, int amount, String email, String ref}) async {
    Charge charge = Charge()
      ..amount = amount
      ..email = email
      ..card = _getCardFromUI()
      ..reference = ref;

    try {
      CheckoutResponse response = await _paystackPlugin.checkout(
        context,
        charge: charge,
        fullscreen: false,
        logo: CircleAvatar(),
        method: CheckoutMethod.card,
      );
      print('Response = $response');
      return response.verify;
    } catch (e) {
      rethrow;
    }
  }

  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: '',
      cvc: '',
      expiryMonth: null,
      expiryYear: null,
    );
  }
}
