import '../common/all_currencies.dart';

class Currency {
  final String currencyCode;
  final String currencyName;

  Currency({
    required this.currencyName,
    required this.currencyCode,
  });

  @override
  List<Object?> get props => [
        currencyName,
        currencyCode,
      ];
  factory Currency.fromCode({required String currencyCode}) {
    final currencies = AllCurrencies.currencies;
    return Currency(
      currencyName: currencies.values.first,
      currencyCode: currencies.keys.singleWhere((key) => key == currencyCode)

    );
  }
}
