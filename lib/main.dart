import 'package:electricity_token/thera_detail.dart';
import 'package:electricity_token/thera_page.dart';
import 'package:electricity_token/thera_viewmodel.dart';
import 'package:electricity_token/payment_method_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<TheraViewModel>(
            create: (context) => TheraViewModel())
        // ChangeNotifierProvider<HomeViewModel>(create: (context) => HomeViewModel()),
      ],
      child: MaterialApp(initialRoute: "/token", routes: {
        "/token": (context) => TheraPage(),
        "/payment_method": (context) => PaymentMethodPage(),
        "/detail": (context) => TheraDetailPage(),
      })));
}
