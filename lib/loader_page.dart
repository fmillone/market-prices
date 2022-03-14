import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings.dart';
import 'ticker_page.dart';
import 'ticker_service.dart';
import 'currency.dart';

class LoaderPage extends ConsumerStatefulWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoaderState();
}

class _LoaderState extends ConsumerState {
  var _future;

  @override
  void initState() {
    _future = Future.wait([
      ref.read(SettingsStore.provider).loadTickersConfig(),
      Future.delayed(const Duration(seconds: 15)),
      if (ref.read(CurrencyList.provider).items.isEmpty)
        ref.read(TickerService.provider).fetchPrices()
    ]).then((value) => redirectToMainView());
    super.initState();
  }

  Future<dynamic> redirectToMainView() {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => const TickerPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: FractionalOffset.center,
      children: const <Widget>[
        CircularProgressIndicator(
            backgroundColor: Colors.red,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
      ],
    );
  }
}
