import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting {
  final String key;
  bool value;

  Setting(this.key, this.value);

  String encode() {
    return '$key|$value';
  }

  factory Setting.decode(String string ) {
    final split = string.split('|');
    final key = split[0];
    final value = split[1];
    return Setting(key, _parseBool(value));
  }
}

bool _parseBool(String? string) {
  return string?.toLowerCase() == 'true';
}


final List<Setting> defaultTickers = [
  Setting('Oficial', true),
  Setting('Blue', true),
  Setting('Liqui', true),
  Setting('Bolsa', true),
  Setting('Turista', true),
  Setting('USD/EUR', true),
  Setting('USD/Real', true),
  Setting('USD/Libra', true),
  Setting('USD/Chileno', true),
  Setting('USD/UY', true),
  Setting('USD/Yuan', true),
  Setting('Dai Ars', true),
  Setting('Dai USD', true),
  Setting('Crypto (dai)', true),
];


class SettingsStore extends ChangeNotifier {
  final List<Setting> _tickers = [];
  static const String tickersCode = 'tickers';

  UnmodifiableListView<Setting> get tickers => UnmodifiableListView(_tickers);

  void loadTickers() async {
    final prefs = await SharedPreferences.getInstance();
    final tickers = prefs.getStringList(tickersCode);
    print('loadTickers: $tickers');
    if(tickers == null) {
      _tickers.clear();
      _tickers.addAll(defaultTickers);
    } else {
      _tickers.clear();
      _tickers.addAll(tickers.map((string) => Setting.decode(string)));
    }
    notifyListeners();
  }

  void saveTickers() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(tickersCode, _tickers.map((setting) => setting.encode()).toList());
  }

  void reorderTickers(int oldIndex, int newIndex) {
    print('reordering $oldIndex to $newIndex');
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final Setting item = _tickers.removeAt(oldIndex);
    _tickers.insert(newIndex, item);
    notifyListeners();
  }

}
