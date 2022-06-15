import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings.dart';
import 'ticker_page.dart';
import 'ticker_service.dart';
import 'ticker_price.dart';

class LoaderPage extends ConsumerStatefulWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoaderState();
}

class _LoaderState extends ConsumerState {

  @override
  void initState() {
    Future.wait([
      ref.read(SettingsStore.provider).loadTickersConfig(),
      Future.delayed(const Duration(seconds: 2)),
      if (ref.read(PriceList.provider).items.isEmpty)
        ref.read(TickerService.provider).fetchPrices()
    ]).then((_) => redirectToMainView());
    super.initState();
  }

  Future<dynamic> redirectToMainView() {
    return Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => const TickerPage()), (route) => false);
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
