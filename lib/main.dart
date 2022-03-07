import 'package:flutter/material.dart';
import 'package:market_prices/buenbit_service.dart';
import 'package:market_prices/dolar_service.dart';

import 'Currency.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Prices',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Market Prices'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Currency> _dollars = [];
  final dolarSiService = DolarSiService();
  final buenbitService = BuenbitService();


  @override
  void initState() {
    super.initState();
    _updateDollars();
  }

  void _updateDollars() async {
    final dollarData = await dolarSiService.getDollars();
    final currenciesData = await dolarSiService.getCurrencies();
    final daisData = await buenbitService.getDai();
    setState(() {
      _dollars.clear();
      _dollars.add(dollarData['Oficial']!);
      _dollars.add(dollarData['Blue']!);
      _dollars.add(dollarData['Liqui']!);
      _dollars.add(dollarData['Bolsa']!);
      _dollars.add(dollarData['Turista']!);

      _dollars.add(currenciesData['USD/EUR']!);
      _dollars.add(currenciesData['USD/Real']!);
      _dollars.add(currenciesData['USD/Libra']!);
      _dollars.add(currenciesData['USD/Chileno']!);
      _dollars.add(currenciesData['USD/UY']!);
      _dollars.add(currenciesData['USD/Yuan']!);

      _dollars.add(daisData['Dai Ars']!);
      _dollars.add(daisData['Dai USD']!);
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: centerView(),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateDollars,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Color getColor(double? variation) {
    if(variation != null) {
      if(variation > 0) {
        return Colors.green.shade400;
      } else if(variation < 0) {
        return Colors.redAccent.shade200;
      } else {
        return Colors.black12;
      }
    } else {
      return Colors.black12;
    }
  }

  Widget tickerBox(Currency e) {
    return Container(
        padding: const EdgeInsets.all(8),
        color: getColor(e.variation),
        child: RichText(
          text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: e.name.replaceAll('Dolar ', ''),
                  style: Theme.of(context).textTheme.headline5,
                ),
                const TextSpan( text: '\n\n'),
                TextSpan(
                  text: formatPrices(e) ,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ]
          ),
        ),
      );
  }

  Widget centerView() {
    return CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: _dollars.map((e) => tickerBox(e)).toList(),
          ),
        ),
      ],
    );
  }

  String formatDouble(double number){
    return number.toStringAsFixed(2);
  }

  String formatPrices(Currency data) {
    if (data.buy == null) {
      return formatDouble(data.sell);
    } else {
      return '${formatDouble(data.buy!)} / ${formatDouble(data.sell)}';
    }
  }

}
