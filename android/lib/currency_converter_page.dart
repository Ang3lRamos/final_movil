import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ConverterPage extends StatefulWidget {
  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  TextEditingController _controller = TextEditingController();
  String _result = '';

  Future<void> _convertCurrency() async {
    final double amount = double.tryParse(_controller.text) ?? 0.0;

    if (amount <= 0) {
      setState(() {
        _result = 'Por favor, ingrese un valor válido.';
      });
      return;
    }

    final String consumer = 'Angel Ramos';
    final String baseCurrency = 'COP'; // Moneda base (pesos colombianos)
    final List<String> targetCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'CNY']; // Divisas de destino
    final String apiKey = '52648|s9cCqvavvDN7GdF79BVQ';

    final String url =
        'https://api.cambio.today/v1/full/$baseCurrency/json?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url), headers: {'consumer': consumer});

      // Imprime el encabezado consumer para verificar si está configurado correctamente
      print('Header consumer: ${response.request!.headers['consumer']}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> conversionData = data['result']['conversion'];

        StringBuffer resultBuffer = StringBuffer();

        for (String targetCurrency in targetCurrencies) {
          final Map<String, dynamic>? desiredConversion = conversionData.firstWhere((conversion) => conversion['to'] == targetCurrency, orElse: () => null);

          if (desiredConversion != null) {
            final double rate = desiredConversion['rate'];
            final double convertedAmount = amount * rate;
            resultBuffer.writeln('$amount COP = $convertedAmount $targetCurrency');
          } else {
            resultBuffer.writeln('No se encontró la tasa de conversión para $targetCurrency.');
          }
        }

        setState(() {
          _result = resultBuffer.toString();
        });
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _result = 'Error al obtener datos de conversión';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Ingrese el valor en COP'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _convertCurrency,
              child: Text('Convertir'),
            ),
            SizedBox(height: 20),
            Text('Resultado de la conversión:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_result),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
