import 'dart:convert';

import 'package:http/http.dart' as http;

class CurrencyService {
  final url = Uri.parse(
      'https://api.freecurrencyapi.com/v1/latest?apikey=fca_live_Y0KvKP1tIDcKGlzh1WcyeF4uIfKASNPw7DScAe5B');

  Future<List<String>> getCurrencies() async {
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body.containsKey('data')) {
        var list = body['data'];
        List<String> currencies = (list.keys).toList();
        print('Currencies: $currencies');
        return currencies;
      } else {
        throw Exception('Data sahəsi cavabda tapılmadı.');
      }
    } else {
      throw Exception(
          'Failed to connect to API, status code: ${response.statusCode}');
    }
  }

  Future<double> getRate(String from, String to) async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      if (body.containsKey('data')) {
        var rates = body['data'];
        if (rates.containsKey(from) && rates.containsKey(to)) {
          double fromRate =
              rates[from] is int ? rates[from].toDouble() : rates[from];
          double toRate = rates[to] is int ? rates[to].toDouble() : rates[to];

          return toRate / fromRate;
        } else {
          throw Exception('tapilmadi.');
        }
      } else {
        throw Exception('Data sahəsi cavabda tapılmadı.');
      }
    } else {
      throw Exception(
          'Failed to connect to API, status code: ${response.statusCode}');
    }
  }
}
