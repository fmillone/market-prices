import 'dart:collection';

import 'package:flutter/foundation.dart';

class Currency {
  final String name;
  final double sell;
  final double? buy;
  final double? variation;

  Currency({ required this.name, required this.sell, required this.buy, this.variation});

}

class CurrencyList extends ChangeNotifier {
  /// Internal, private state of the cart.
  final List<Currency> _items = [];

  /// An unmodifiable view of the items in the cart.
  UnmodifiableListView<Currency> get items => UnmodifiableListView(_items);

  /// Adds [item] to cart. This and [removeAll] are the only ways to modify the
  /// cart from the outside.
  void add(Currency item) {
    _items.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void addAll(Iterable<Currency> items) {
    _items.addAll(items);
    notifyListeners();
  }

  /// Removes all items from the cart.
  void clear() {
    _items.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void replaceAll(Iterable<Currency> items) {
    _items.clear();
    addAll(items);
  }
}