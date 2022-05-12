import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/currency_bloc/currency_bloc.dart';
import '../../core/repository/currency_repository.dart';
import 'currency_page.dart';

class CurrencyProvider extends StatelessWidget {
  const CurrencyProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CurrencyBloc(currencyRepository: CurrencyRepository()),
        child: CurrencyPage(),
    );
  }
}
