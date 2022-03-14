import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'ticker_price.dart';
import 'settings_page.dart';
import 'ticker_service.dart';

class TickerPage extends ConsumerStatefulWidget {
  const TickerPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TickerPage> createState() => _TickerPageState();
}

class _TickerPageState extends ConsumerState<TickerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: centerView(list),
      floatingActionButton: FloatingActionButton(
        onPressed: ref.read(TickerService.provider).refreshTickers,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Color getColor(double? variation) {
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

  Widget tickerBox(TickerPrice e) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: getColor(e.variation),
      child: FittedBox(
        child: RichText(
          text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: e.name.replaceAll('Dolar ', ''),
              style: Theme.of(context).textTheme.headline5,
            ),
            const TextSpan(text: '\n\n'),
            TextSpan(
              text: formatPrices(e),
              style: Theme.of(context).textTheme.headline6,
            ),
          ]),
        ),
      ),
    );
  }

  Widget centerView(Iterable<TickerPrice> list) {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: sliver(list),
        ),
      ],
    );
  }

  Widget sliver(Iterable<TickerPrice> list) {
    return SliverGrid.count(
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: MediaQuery.of(context).size.width ~/ 130,
      children: list.map((e) => tickerBox(e)).toList(),
    );
  }

  String formatDouble(double number) {
    return number.toStringAsFixed(2);
  }

  String formatPrices(TickerPrice data) {
    if (data.buy == null) {
      return formatDouble(data.sell);
    } else {
      return '${formatDouble(data.buy!)} / ${formatDouble(data.sell)}';
    }
  }
}
