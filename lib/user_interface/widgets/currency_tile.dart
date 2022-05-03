import 'package:flutter/material.dart';
import '../../data/models/currency_model.dart';

class CurrencyTile extends StatefulWidget {
  const CurrencyTile({
    Key? key,
    required this.currency,
    required this.isHint,
  }) : super(key: key);
  final Currency currency;
  final bool isHint;

  @override
  State<CurrencyTile> createState() => _CurrencyTileState();
}

class _CurrencyTileState extends State<CurrencyTile> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.fromLTRB(7, 7, 15, 7),
          color: Colors.black.withOpacity(0.4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10.0),
              widget.isHint == true
                  ? Text(
                      widget.currency.currencyCode,
                      style: TextStyle(fontSize: 25, color: Colors.white)
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.currency.currencyCode,
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,),
                          ),
                        Text(
                          widget.currency.currencyName,
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                              color: Colors.white),
                        )
                  ],
                ),
            ],
          ),
        ),
    );
  }
}
