import 'package:electricity_token/api_error.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatCurrency {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

String moneyFormatter(int? price) {
  return FormatCurrency.convertToIdr(price, 0);
}

Row keyValue(String label, String text) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(label), Text(text)],
  );
}

String formatDate(String datetime) {
  var dateFormatted =
      DateFormat("d MMM yyyy, HH:mm").format(DateTime.parse(datetime));

  return dateFormatted;
}