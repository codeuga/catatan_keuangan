import 'package:intl/intl.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number) {
    NumberFormat CurrencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 2,
    );

    return CurrencyFormatter.format(number);
  }
}
