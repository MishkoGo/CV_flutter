part of 'currency_bloc.dart';

class CurrencyState {
  const CurrencyState();

  @override
  List<Object> get props => [];
}

class CurrencyLoadedState extends CurrencyState {
  final CurrencyPair currencyPairModel;

  const CurrencyLoadedState(this.currencyPairModel);

  @override
  List<Object> get props => [currencyPairModel];

  Map<String, dynamic> toJson() {
    return {'value': currencyPairModel.toJson()};
  }

  factory CurrencyLoadedState.fromJson(Map<String, dynamic> json) {
    return CurrencyLoadedState(CurrencyPair.fromJson(json['value']));
  }
}

class CurrencyFailedState extends CurrencyState {
  final String error;
  CurrencyFailedState({required this.error});
}
