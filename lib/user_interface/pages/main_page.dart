import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:intl/intl.dart' as intl;
import 'package:untitled1/user_interface/pages/search_page.dart';
import '../../currency_bloc/currency_bloc.dart';
import '../../data/models/currency_model.dart';
import '../../data/models/currency_pair.dart';
import '../../data/repositories/currency_repository.dart';
import '../widgets/currency_tile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
      body: BlocProvider(
        create: (context) => _currencyBloc,
        child: SafeArea(
          child: BlocBuilder<CurrencyBloc, CurrencyState>(
            bloc: _currencyBloc,
            builder: (context, state) {
              if (state is CurrencyLoadedState) {
                _currentCurrencyPair = state.currencyPairModel;
                _textControllers();
                return Column(
                  children: [
                    SizedBox(height: 40,),
                    _currencyPair(),
                    _calculator(),
                  ],
                );
              } else if (state is CurrencyFailedState) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 10),
                      child: Text(
                        state.error,
                        style: TextStyle()
                            .copyWith(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _calculator(),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void _textControllers() {
    final currencyFormat = intl.NumberFormat("#,##0.00", "en_US");
    _baseTextEditingController.text =
        currencyFormat.format(_currentCurrencyPair.amount);
    _toTextEditingController.text =
        currencyFormat.format(_currentCurrencyPair.output);
  }

  void _onClick(double? value) {
    _currentCurrencyPair = _currentCurrencyPair.copyWith(
        amount: value ?? 0,
        output: ((value ?? 0) * _currentCurrencyPair.exchangeRate));
    _currencyBloc.add(SwitchCurrenciesEvent(_currentCurrencyPair));
  }

  Widget _calculator() {
    return Expanded(
      flex: 1,
      child: SimpleCalculator(
        onChanged: (key, value, expression) => _onClick(value),
        hideSurroundingBorder: true,
        hideExpression: true,
        theme: const CalculatorThemeData(
          borderWidth: 10,
            numColor: Colors.white,
            operatorColor: Colors.white,
            commandColor: Colors.white,
            commandStyle: TextStyle(
                fontSize: 20,
              color: Colors.blue,
            ),
            operatorStyle: TextStyle(
                fontSize: 20,
              color: Colors.red
            ),
            numStyle: TextStyle(fontSize: 30, color: Colors.black),
            displayStyle: TextStyle(
                color: Colors.transparent,
                fontSize: 0,
            )),
      ),
    );
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
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 30,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                readOnly: true,
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
      padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
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
