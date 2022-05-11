import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../currency_bloc/currency_bloc.dart';
import '../../models/currency_model.dart';
import '../../repository/currency_repository.dart';
import '../widgets/currency_tile.dart';

class SearchCurrencyBottomSheet extends StatefulWidget {
  const SearchCurrencyBottomSheet({
    Key? key,
    required this.isBaseCurrency,
  }) : super(key: key);

  final bool isBaseCurrency;

  @override
  State<SearchCurrencyBottomSheet> createState() =>
      _SearchCurrencyBottomSheetState();
}

class _SearchCurrencyBottomSheetState extends State<SearchCurrencyBottomSheet> {
  late CurrencyBloc _currencyConversionBloc;
  List<Currency> _currenciesFound = [];
  final _allCurrencies = CurrencyRepository().getAllCurrencies();

  @override
  void initState() {
    _currenciesFound = _allCurrencies;
    _currencyConversionBloc = context.read<CurrencyBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.75,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        color: Colors.black.withOpacity(0.3),
        child: Column(
          children: [
            SizedBox(height: 10,),
            _buildListView(scrollController),
          ],
        ),
      ),
    );
  }

  BlocBuilder<CurrencyBloc, CurrencyState> _buildListView(
      ScrollController scrollController) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      bloc: _currencyConversionBloc,
      builder: (context, state) {
        return Expanded(
          child: _currenciesFound.isNotEmpty
              ? ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 5),
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _currenciesFound.length,
                  itemBuilder: (context, index) {
                    if (state is CurrencyLoadedState) {
                      return GestureDetector(
                        onTap: () => _onTileTap(index, state),
                        child: CurrencyTile(
                          currency: _currenciesFound[index],
                          isHint: false,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              : Text(
                  'No currency found',
                  style: TextStyle().copyWith(fontSize: 15),
                ),
        );
      },
    );
  }

  void _onTileTap(int index, CurrencyLoadedState state) {
    Navigator.of(context).pop();
    if (widget.isBaseCurrency) {
      _currencyConversionBloc.add(ConvertCurrenciesEvent(
        amount: state.currencyPairModel.amount,
        baseCurrency: _currenciesFound[index],
        toCurrency: state.currencyPairModel.toCurrency,
      ));
    } else if (!widget.isBaseCurrency) {
      _currencyConversionBloc.add(ConvertCurrenciesEvent(
        amount: state.currencyPairModel.amount,
        baseCurrency: state.currencyPairModel.baseCurrency,
        toCurrency: _currenciesFound[index],
      ));
    }
  }
}
