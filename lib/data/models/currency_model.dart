import 'package:equatable/equatable.dart';
import '../../core/consts/all_currencies.dart';

class Currency extends Equatable {
  final String currencyCode;
  final String currencyName;

  const Currency({
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
      currencyName: currencies[currencyCode]!.entries.first.key,
      currencyCode: currencies.keys.singleWhere((key) => key == currencyCode),
    );
  }
}
