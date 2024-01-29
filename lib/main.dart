import 'dart:async';
import 'dart:convert';
import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool themeIsDark = false;
  List<String> data = [];
  List<Candle> candles = [];

  @override
  void initState() {
    super.initState();
    // Start fetching data immediately
    // Set up a timer to fetch data every 5 seconds (adjust as needed)
    Timer.periodic(Duration(seconds: 1), (timer) {
      fetchCandles().then((value) {
      setState(() {
        candles = value;
      });
    });
    });
  }

  Future<List<Candle>> fetchCandles() async {
    final Uri uri = Uri.parse("https://api.binance.com/api/v3/klines");
    final Map<String, String> queryParameters = {
      'symbol': 'BTCUSDT',
      'interval': '1m',
    };

    final Uri finalUri = uri.replace(queryParameters: queryParameters);

    final res = await http.get(finalUri);

     return (jsonDecode(res.body) as List<dynamic>)
        .map((e) => Candle.fromJson(e))
        .toList()
        .reversed
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeIsDark ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("BTCUSDT Real-Time Chart"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  themeIsDark = !themeIsDark;
                });
              },
              icon: Icon(
                themeIsDark
                    ? Icons.wb_sunny_sharp
                    : Icons.nightlight_round_outlined,
              ),
            )
          ],
        ),
        body: Candlesticks(
            candles: candles,
          ),
      ),
    );
  }
}
