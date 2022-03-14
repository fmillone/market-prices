import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'buenbit_service.dart';
import 'currency.dart';
import 'dolar_service.dart';
import 'settings.dart';

class TickerService {
  static final provider = Provider((ref) => TickerService(
        ref.read(CurrencyList.provider),
        DolarSiService(),
        BuenbitService(),
      ));

  static final filteredProvider = Provider<Iterable<Currency>>((ref) {
    final list = ref.watch(CurrencyList.provider);
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

  final CurrencyList _currencyList;
  final DolarSiService _dolarSiService;
  final BuenbitService _buenbitService;

  TickerService(this._currencyList, this._dolarSiService, this._buenbitService);

  void refreshTickers({bool clear = true}) async {
    if (clear) {
      _currencyList.clear();
    }

    fetchPrices();
  }

  Future<void> fetchPrices() async {
    List<Map<String, Currency>> maps =
        await Future.wait([_dolarSiService.getAll(), _buenbitService.getDai()]);
    _currencyList.addAllIt({...maps[0], ...maps[1]});
  }
}
