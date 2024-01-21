import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String text;

  const PaymentPage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('My number is: $text'),
      ),
    );
  }
}