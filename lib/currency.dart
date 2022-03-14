import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Currency {
  final String name;
  final double sell;
  final double? buy;
  final double? variation;

  Currency({ required this.name, required this.sell, required this.buy, this.variation});

}

class CurrencyList extends ChangeNotifier {
  static final provider = ChangeNotifierProvider<CurrencyList>((ref) => CurrencyList());
  final Map<String, Currency> _it = {};

  UnmodifiableMapView<String, Currency> get items => UnmodifiableMapView<String,Currency>(_it);

  void addAllIt(Map<String, Currency> items) {
    _it.addAll(items);
    notifyListeners();
  }

  void clear() {
    _it.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

}