import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../common/all_currencies.dart';
import '../../models/currency_model.dart';
import '../../models/currency_pair.dart';

class CurrencyRepository {
  final _apiKey = 'ed6562f57fc2401a92f2f6f3650f5aba';

  Future<CurrencyPair> convertCurrencies({
    required Currency baseCurrency,
    required Currency toCurrency,
    required double amount,
  }) async {
    try {
      final Uri url = Uri.parse(
          'https://exchange-rates.abstractapi.com/v1/convert?api_key=$_apiKey&base=${baseCurrency.currencyCode}&target=${toCurrency.currencyCode}&base_amount=$amount');
      final response = await http.Client().get(url);

      return CurrencyPair.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }

  List<Currency> getAllCurrencies() {
    List<Currency> list = [];
    AllCurrencies.currencies.forEach((key, value) {
        list.add(
            Currency(currencyName: value, currencyCode: key));
    });
    return list;
  }
}