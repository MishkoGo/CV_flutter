import 'package:CurrencyApp/scenes/pages/currency_page.dart';
import 'package:CurrencyApp/scenes/pages/currency_provider.dart';
import 'package:CurrencyApp/scenes/widgets/navigation_drawer.dart';
import 'package:flutter/material.dart';


class CurrencyApp extends StatelessWidget {
  const CurrencyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData.dark(),
        theme: ThemeData.light(),
        home: Scaffold(
          drawer: NavigationDrawerWidget(),
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text('Currency Converter', style: TextStyle(color: Colors.white),),
            centerTitle: true,
          ),
          body: const CurrencyProvider(),
        )
    );
  }
}
