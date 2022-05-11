import '../models/currency_model.dart';

class CurrencyPair {
  final Currency baseCurrency;
  final Currency toCurrency;
  final double amount;
  final int lastUpdated;
  final double exchangeRate;
  final double output;

  CurrencyPair({
    required this.baseCurrency,
    required this.toCurrency,
    required this.amount,
    required this.lastUpdated,
    required this.exchangeRate,
    required this.output,
  });

  @override
  List<Object?> get props => [
        baseCurrency,
        toCurrency,
        amount,
        lastUpdated,
        exchangeRate,
        output,
      ];

  Map<String, dynamic> toJson() {
    return {
      'base': baseCurrency.currencyCode,
      'target': toCurrency.currencyCode,
      'base_amount': amount,
      'last_updated': lastUpdated,
      'exchange_rate': exchangeRate,
      'converted_amount': output,
    };
  }

  factory CurrencyPair.fromJson(
    Map<String, dynamic> json,
  ) {
    var data = CurrencyPair(
      baseCurrency: Currency.fromCode(currencyCode: json['base']),
      toCurrency: Currency.fromCode(currencyCode: json['target']),
      amount: double.parse(json['base_amount'].toString()),
      lastUpdated: json['last_updated'],
      exchangeRate: double.parse(json['exchange_rate'].toString()),
      output: double.parse(json['converted_amount'].toString()),
    );
    return data;
  }

  CurrencyPair copyWith({
    Currency? baseCurrency,
    Currency? toCurrency,
    double? amount,
    int? lastUpdated,
    double? exchangeRate,
    double? output,
  }) {
    return CurrencyPair(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      output: output ?? this.output,
    );
  }
}
