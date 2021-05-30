import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PayStackNotifier with ChangeNotifier {
  PaystackPlugin _paystackPlugin;

  PayStackNotifier.initialize(this._paystackPlugin) {
    _paystackPlugin.initialize(publicKey: 'pk_test_c1cfac0c6cbf5a6c5432ccafb3815a274f912d4a');
  }

  // PaymentCard card;
}
