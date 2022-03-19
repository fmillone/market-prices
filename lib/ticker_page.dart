import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ticker_price.dart';
import 'settings_page.dart';
import 'ticker_service.dart';

class TickerPage extends ConsumerWidget {
  const TickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(PriceList.filtered);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Prices'),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
        ),
      ),
      body: centerView(list, context),
      floatingActionButton: FloatingActionButton(
        onPressed: ref.read(TickerService.provider).refreshTickers,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget centerView(Iterable<TickerPrice> list, BuildContext context) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: sliver(list, context),
        ),
      ],
    );
  }

  Widget sliver(Iterable<TickerPrice> list, BuildContext context) {
    return SliverGrid.count(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: MediaQuery.of(context).size.width ~/ 130,
      children: list.map((e) => TickerBox(e)).toList(),
    );
  }
}

class TickerBox extends ConsumerWidget {
  TickerBox(this._price, {Key? key}) : super(key: key);
  final TickerPrice _price;
  final StateProvider<bool> _showAverage = StateProvider((ref) => false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final showAvg = ref.read(_showAverage.state);
        showAvg.state = !showAvg.state;
      },
    child: Container(
      padding: const EdgeInsets.all(8),
      color: _getColor(_price.variation),
      child: FittedBox(
        child: ref.watch(_showAverage.state).state ? _getAverageBox(context) : _getPricesBox(context),
      ),
    ),
    );
  }

  Widget _getAverageBox(BuildContext context) {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text: 'Avg',
          style: Theme.of(context).textTheme.headline5,
        ),
        const TextSpan(text: '\n\n'),
        TextSpan(
          text: _calcAvg(),
          style: Theme.of(context).textTheme.headline6,
        ),
      ]),
    );
  }

  Widget _getPricesBox(BuildContext context) {
    return RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text: _price.name.replaceAll('Dolar ', ''),
          style: Theme.of(context).textTheme.headline5,
        ),
        const TextSpan(text: '\n\n'),
        TextSpan(
          text: _formatPrices(_price),
          style: Theme.of(context).textTheme.headline6,
        ),
      ]),
    );
  }

  String _calcAvg() {
    if(_price.buy != null) {
      return ((_price.buy! + _price.sell ) / 2).toStringAsFixed(2);
    } else {
      return _price.sell.toStringAsFixed(2);
    }
  }

  Color _getColor(double? variation) {
    if (variation != null) {
      if (variation > 0) {
        return Colors.green.shade400;
      } else if (variation < 0) {
        return Colors.redAccent.shade200;
      } else {
        return Colors.black12;
      }
    } else {
      return Colors.black12;
    }
  }

  String _formatDouble(double number) {
    return number.toStringAsFixed(2);
  }

  String _formatPrices(TickerPrice data) {
    if (data.buy == null) {
      return _formatDouble(data.sell);
    } else {
      return '${_formatDouble(data.buy!)} / ${_formatDouble(data.sell)}';
    }
  }

}