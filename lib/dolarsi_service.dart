import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import 'ticker_price.dart';

final Map<String, String> dollarKinds = {
  'Oficial': 'casa349',
  'Blue': 'casa310',
  'Liqui': 'casa312',
  'Bolsa': 'casa313',
  'Turista': 'casa406'
};

final Map<String, String> currencyKinds = {
  'USD/EUR': 'casa193',
  'USD/Real': 'casa270',
  'USD/Libra': 'casa50',
  'USD/Chileno': 'casa81',
  'USD/UY': 'casa55',
  'USD/Yuan': 'casa393',
};

double toDouble(String string) {
  return double.parse(string.replaceAll(',', '.'));
}

extension _XmlElementExtension on XmlElement {

  double? getAsDoubleIfEqualToValue({required String name, required String? value}) {
    var text = getElement(name)?.text;
    return text != value ? toDouble(text?? '') : null;
  }
}

class DolarSiService {
  XmlElement? parseResponse(String body) {
    return XmlDocument.parse(body).getElement('cotiza');
  }

  Map<String, TickerPrice> mapValuesToCurrencyObjects(
      XmlElement element, Map<String, String> kinds) {
    final Map<String, TickerPrice> map = {};

    kinds.forEach((key, value) {
      final elem = element.getElement(value);
      if (elem != null) {
        map[key] = TickerPrice(
            name: key,
            sell: toDouble(elem.getElement('venta')!.text),
            buy: elem.getAsDoubleIfEqualToValue(name: 'compra', value: 'No Cotiza'),
            variation: elem.getAsDoubleIfEqualToValue(name: 'variacion', value: null));
      }
    });
    return map;
  }

  Future<Map<String, TickerPrice>> getDollars() async {
    final mainValues =
        (await fetchDollarSiData()).getElement('valores_principales');
    if (mainValues != null) {
      return mapValuesToCurrencyObjects(mainValues, dollarKinds);
    } else {
      throw Exception('Failed to get main values from response');
    }
  }

  Future<Map<String, TickerPrice>> getCurrencies() async {
    final currencies = (await fetchDollarSiData()).getElement('Monedas');
    if (currencies != null) {
      return mapValuesToCurrencyObjects(currencies, currencyKinds);
    } else {
      throw Exception('Failed to get currencies from response');
    }
  }

  Future<Map<String, TickerPrice>> getAll() async {
    final xmlElement = await fetchDollarSiData();
    final mainValues = xmlElement.getElement('valores_principales');
    final Map<String, TickerPrice> map = {};

    if (mainValues != null) {
      map.addAll(mapValuesToCurrencyObjects(mainValues, dollarKinds));
    } else {
      throw Exception('Failed to get main values from response');
    }

    final currencies = xmlElement.getElement('Monedas');
    if (currencies != null) {
      map.addAll(mapValuesToCurrencyObjects(currencies, currencyKinds));
    } else {
      throw Exception('Failed to get currencies from response');
    }

    return map;
  }

  Future<XmlElement> fetchDollarSiData() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.dolarsi.com/api/dolarSiInfo.xml'));

      if (response.statusCode == 200) {
        final parsedResponse = parseResponse(response.body);
        if (parsedResponse != null) {
          return parsedResponse;
        } else {
          throw Exception('Failed to parse response');
        }
      } else {
        throw Exception('Failed to load dollar info');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to get data from dolarsi due to $e');
    }
  }
}
