class PriceConstants {
  static const double minPriceUSD = 0;
  static const double maxPriceUSD = 10000;

  static const double exchangeRateSYP = 15000;

  static double get minPriceSYP => minPriceUSD * exchangeRateSYP;
  static double get maxPriceSYP => maxPriceUSD * exchangeRateSYP;
}
