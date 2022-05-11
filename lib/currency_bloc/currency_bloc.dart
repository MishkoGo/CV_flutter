import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/currency_model.dart';
import '../models/currency_pair.dart';
import '../repository/currency_repository.dart';
part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository currencyRepository;
  static final CurrencyPair _mockData = CurrencyPair(
    baseCurrency: Currency.fromCode(currencyCode: 'USD'),
    toCurrency: Currency.fromCode(currencyCode: 'EUR'),
    amount: 10,
    lastUpdated: (DateTime.now().millisecondsSinceEpoch ~/ 1000),
    exchangeRate: 0.92,
    output: 1 * 0.92,
  );

  CurrencyBloc({required this.currencyRepository})
      : super(CurrencyLoadedState(_mockData)) {
    on<SwitchCurrenciesEvent>(
        (event, emit) => emit(CurrencyLoadedState(event.pair)));
    on<ConvertCurrenciesEvent>(((event, emit) async {
        var currencyPair = await currencyRepository.convertCurrencies(
          baseCurrency: event.baseCurrency,
          toCurrency: event.toCurrency,
          amount: event.amount,
        );
        emit(CurrencyLoadedState(currencyPair));
      }
    ));
  }

}
