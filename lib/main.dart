import 'package:flutter/material.dart';
import './currency_converter_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      home: ConverterPage(),
    );
  }
}
