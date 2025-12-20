import '../resources/price_constants.dart';

class PriceFormatter {
  static String format(double priceInUsd, String currencyCode) {
    if (currencyCode == 'SYP') {
      final sypPrice = priceInUsd * PriceConstants.exchangeRateSYP;
      return "${_addCommas(sypPrice.toStringAsFixed(0))} SYP";
    } else {
      return "\$${_addCommas(priceInUsd.toStringAsFixed(0))}";
    }
  }

  static String formatShort(double priceInUsd, String currencyCode) {
    if (currencyCode == 'SYP') {
      final sypPrice = priceInUsd * PriceConstants.exchangeRateSYP;
      if (sypPrice >= 1000000) {
        return "${(sypPrice / 1000000).toStringAsFixed(1)}M SYP";
      }
      if (sypPrice >= 1000) {
        return "${(sypPrice / 1000).toStringAsFixed(0)}K SYP";
      }
      return "${_addCommas(sypPrice.toStringAsFixed(0))} SYP";
    } else {
      return "\$${_addCommas(priceInUsd.toStringAsFixed(0))}";
    }
  }

  static String _addCommas(String price) {
    return price.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
