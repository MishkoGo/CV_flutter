import 'package:CurrencyApp/scenes/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import '../../bloc/currency_bloc/currency_bloc.dart';
import '../../core/repository/currency_repository.dart';
import '../../models/currency_model.dart';
import '../../models/currency_pair.dart';
import '../widgets/currency_tile.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {

  final _currencyBloc = CurrencyBloc(currencyRepository: CurrencyRepository());
  final _baseTextEditingController = TextEditingController();
  final _toTextEditingController = TextEditingController();
  late CurrencyPair _currentCurrencyPair;

  @override
  void dispose() {
    super.dispose();
    _currencyBloc.close();
    _baseTextEditingController.dispose();
    _toTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CurrencyBloc, CurrencyState>(
            bloc: _currencyBloc,
            builder: (context, state) {
              if (state is CurrencyLoadedState) {
                _currentCurrencyPair = state.currencyPairModel;
                _textControllers();
                _getLastUpdated();
                return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40,),
                      Container(
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.indigo.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 3)
                            )
                          ]
                        ),
                        child: _currencyPair(),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Text(_getLastUpdated(), style: TextStyle(color: Colors.black),),
                      )
                    ],
                  ),
                );
              } else if (state is CurrencyFailedState){
                return Center(
                 child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text(
                        state.error,
                        style: TextStyle().copyWith(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                );
              }
              return Container();
            },
          ),
        );
  }

  String _getLastUpdated() {
    var lastUpdated = DateTime.fromMillisecondsSinceEpoch(
        (_currentCurrencyPair.lastUpdated * 1000),
        isUtc: false);
    var hoursMinutes = intl.DateFormat.Hm().format(lastUpdated);
    var yearMonthDay = intl.DateFormat.yMd().format(lastUpdated);
    return 'Last updated: $yearMonthDay $hoursMinutes';
  }

  void _textControllers() {
    final currencyFormat = intl.NumberFormat("#,##0.00", "en_US");
    _baseTextEditingController.text =
        currencyFormat.format(_currentCurrencyPair.amount);
    _toTextEditingController.text =
        currencyFormat.format(_currentCurrencyPair.output);
  }

  void _showModalBottomSheet(bool isBaseCurrency) {
    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => BlocProvider.value(
              value: _currencyBloc,
              child: SearchCurrencyBottomSheet(isBaseCurrency: isBaseCurrency),
            ));
  }


  Widget _currencyWidget({
    required Currency currency,
    required bool isBaseCurrency,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            flex: 0,
            child: GestureDetector(
                onTap: () => _showModalBottomSheet(isBaseCurrency),
                child: CurrencyTile(
                  currency: currency,
                  isHint: true,
                )),
          ),

          Expanded(
              flex: 1,
              child: TextField(
                onSubmitted: (value) {
                  _currentCurrencyPair = _currentCurrencyPair.copyWith(
                      amount: double.tryParse(value) ?? 0,
                      output: ((double.tryParse(value) ?? 0) * _currentCurrencyPair.exchangeRate));
                  _currencyBloc.add(SwitchCurrenciesEvent(_currentCurrencyPair));
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                ),
                decoration: const InputDecoration(
                    border: InputBorder.none
                ),
                controller: isBaseCurrency == true
                    ? _baseTextEditingController
                    : _toTextEditingController,
              )),
        ],
      ),
    );
  }

  void _switchCurr() {
    var prevBase = _currentCurrencyPair.baseCurrency;
    var prevTo = _currentCurrencyPair.toCurrency;
    var invertRate = 1 / _currentCurrencyPair.exchangeRate;
    bool isReversed = true;
    _currentCurrencyPair = _currentCurrencyPair.copyWith(
      baseCurrency: prevTo,
      toCurrency: prevBase,
      exchangeRate:
          isReversed == true ? invertRate : _currentCurrencyPair.exchangeRate,
      output: _currentCurrencyPair.amount *
          (isReversed == true ? invertRate : _currentCurrencyPair.exchangeRate),
    );
    isReversed = false;
    _currencyBloc.add(SwitchCurrenciesEvent(_currentCurrencyPair));
  }

  Widget _currencyPair() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Column(
        children: [
          _currencyWidget(
            isBaseCurrency: true,
            currency: _currentCurrencyPair.baseCurrency,
          ),
          TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.only(
                    top: 20,
                    bottom: 20,
                  )),
                  overlayColor:
                      MaterialStateProperty.all(Colors.black.withOpacity(0.2)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)))),
              onPressed: () => _switchCurr(),
              child: Icon(
                Icons.swap_vert_rounded,
                color: Colors.black,
              )),
          _currencyWidget(
            isBaseCurrency: false,
            currency: _currentCurrencyPair.toCurrency,
          ),
        ],
      ),
    );
  }
}
