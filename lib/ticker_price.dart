import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'settings.dart';

class TickerPrice {
  final String name;
  final double sell;
  final double? buy;
  final double? variation;

  TickerPrice({ required this.name, required this.sell, required this.buy, this.variation});

}

class PriceList extends ChangeNotifier {
  static final provider = ChangeNotifierProvider<PriceList>((ref) => PriceList());

  static final filtered = Provider<Iterable<TickerPrice>>((ref) {
    final list = ref.watch(PriceList.provider);
    final settings = ref.watch(SettingsStore.provider);
    if (list.items.isEmpty) {
      print('WARN!: rendering empty tickers');
      return [];
    } else {
      return settings.tickers
          .where((e) => e.value)
          .map((e) => list.items[e.key]!)
          .toList();
    }
  });

  final Map<String, TickerPrice> _it = {};

  UnmodifiableMapView<String, TickerPrice> get items => UnmodifiableMapView<String,TickerPrice>(_it);

  void addAllIt(Map<String, TickerPrice> items) {
    _it.addAll(items);
    notifyListeners();
  }

  void clear() {
    _it.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

}