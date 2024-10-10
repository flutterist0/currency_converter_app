import 'package:currency_converter_app/models/currency.dart';
import 'package:currency_converter_app/service/currency_service.dart';
import 'package:currency_converter_app/widgets/custome_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> currencies = [];
  String from = '';
  String to = '';
  double rate = 0;
  String result = '';
  String amount = '';
  CurrencyService currencyService = CurrencyService();
  Future<List<String>> fetchCurrencies() async {
    return await currencyService.getCurrencies();
  }

  @override
  void initState() {
    super.initState();

    fetchCurrencies().then((list) {
      setState(() {
        currencies = list;

        if (currencies.isNotEmpty) {
          from = currencies[31];
          to = currencies[30];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(currencies.length);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Center(
        child: IntrinsicWidth(
          stepWidth: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter amount',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  onChanged: (value) async {
                    amount = value;
                    if (value.isEmpty) {
                      setState(() {
                        result = '';
                      });
                    } else {
                      rate = await currencyService.getRate(from, to);
                      double validRate = rate is int ? rate.toDouble() : rate;
                      print("Rate from $from to $to: $rate");
                      setState(() {
                        result = (validRate * double.parse(value))
                            .toStringAsFixed(3);
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customDropDown(currencies, from, (val) {
                      setState(() {
                        from = val!;
                      });
                    }),
                    FloatingActionButton(
                      backgroundColor: Colors.blue,
                      tooltip: 'Swap',
                      onPressed: () async {
                        String temp = from;
                        setState(() {
                          from = to;
                          to = temp;
                        });
                        if (amount.isNotEmpty) {
                          rate = await currencyService.getRate(from, to);
                          double validRate =
                              rate is int ? rate.toDouble() : rate;
                          print("Rate from $from to $to: $rate");
                          setState(() {
                            result = (validRate * double.parse(amount))
                                .toStringAsFixed(3);
                          });
                        }
                      },
                      child: Icon(
                        Icons.swap_horiz,
                      ),
                    ),
                    customDropDown(currencies, to, (val) {
                      setState(() {
                        to = val!;
                      });
                    }),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Result',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      Text(
                        result,
                        style: TextStyle(color: Colors.blue, fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
