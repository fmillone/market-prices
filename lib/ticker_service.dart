import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'buenbit_service.dart';
import 'ticker_price.dart';
import 'dolarsi_service.dart';

class TickerService {
  static final provider = Provider((ref) => TickerService(
        ref.read(PriceList.provider),
        DolarSiService(),
        BuenbitService(),
      ));

  final PriceList _priceList;
  final DolarSiService _dolarSiService;
  final BuenbitService _buenbitService;

  TickerService(this._priceList, this._dolarSiService, this._buenbitService);

  void refreshTickers({bool clear = true}) async {
    if (clear) {
      _priceList.clear();
    }

    fetchPrices();
  }

  Future<void> fetchPrices() async {
    List<Map<String, TickerPrice>> maps =
        await Future.wait([_dolarSiService.getAll(), _buenbitService.getDai()]);
    _priceList.addAllIt({...maps[0], ...maps[1]});
  }
}
