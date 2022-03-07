import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Currency.dart';

final Map<String,String> buenbitKinds = {
  'Dai Ars': 'daiars',
  'Dai USD': 'daiusd',
};

double toDouble(String string) {
  return double.parse(string.replaceAll(',', '.'));
}

class BuenbitService {
  
  Map<String, dynamic>? parseResponse(String body) {
    return jsonDecode(body)['object'];
  }

  Map<String, Currency> mapValuesToCurrencyObjects(Map<String, dynamic> element){
    final Map<String, Currency> map = {};
    buenbitKinds.forEach((key, value) => {
      map[key] = Currency(
        name: 'Dai Ars',
        sell: toDouble(element[value]?['selling_price']),
        buy:  toDouble(element[value]?['purchase_price']),
      )
    });

    map['Crypto (dai)'] = Currency(
      name: 'Crypto (dai)',
      sell: toDouble(element['daiars']?['selling_price']) / toDouble(element['daiusd']?['purchase_price']),
      buy: toDouble(element['daiars']?['purchase_price']) / toDouble(element['daiusd']?['selling_price'])
    );

    return map;
  }

  Future<Map<String, Currency>> getDai() async {
    final data = await fetchBuenbitData();
    return mapValuesToCurrencyObjects(data);
  }

  Future<Map<String, dynamic>> fetchBuenbitData() async {

    try {
      final response = await http
              .get(Uri.parse('https://be.buenbit.com/api/market/tickers/'));

      if (response.statusCode == 200) {
            final parsedResponse = parseResponse(response.body);
            if(parsedResponse != null) {
              return parsedResponse;
            } else {
              throw throw Exception('Failed to parse buenbit response');
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