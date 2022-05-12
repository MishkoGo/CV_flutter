import 'package:CurrencyApp/scenes/pages/currency_provider.dart';
import 'package:flutter/material.dart';


class CurrencyApp extends StatelessWidget {
  const CurrencyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text('Currency Converter', style: TextStyle(color: Colors.white),),
            centerTitle: true,
          ),
          body: const CurrencyProvider(),
        )
    );
  }
}
