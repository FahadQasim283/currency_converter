import 'package:flutter/material.dart';


class CurrencyConverterPage extends StatefulWidget {
  const CurrencyConverterPage({super.key});

  @override
  State<CurrencyConverterPage> createState() => _CurrencyConverterPageState();
}

class _CurrencyConverterPageState extends State<CurrencyConverterPage> {
  final List<String> currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD'];
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  double _amount = 0.0;
  double _convertedAmount = 0.0;
  int _conversionCount = 0;

  final Map<String, Map<String, double>> _exchangeRates = {
    'USD': {'EUR': 0.92, 'GBP': 0.79, 'JPY': 149.50, 'CAD': 1.35},
    'EUR': {'USD': 1.09, 'GBP': 0.86, 'JPY': 162.50, 'CAD': 1.47},
    'GBP': {'USD': 1.27, 'EUR': 1.16, 'JPY': 189.00, 'CAD': 1.71},
    'JPY': {'USD': 0.0067, 'EUR': 0.0062, 'GBP': 0.0053, 'CAD': 0.0091},
    'CAD': {'USD': 0.74, 'EUR': 0.68, 'GBP': 0.58, 'JPY': 109.89},
  };

  void _convertCurrency() {
    if (_conversionCount >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Maximum conversions reached for this login')),
      );
      return;
    }

    setState(() {
      _convertedAmount = _amount * (_exchangeRates[_fromCurrency]![_toCurrency] ?? 1);
      _conversionCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Converter', style: TextStyle()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Conversions: $_conversionCount/2',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade100,
              Colors.deepPurple.shade200,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Enter Amount',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _amount = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCurrencyDropdown(
                          value: _fromCurrency,
                          onChanged: (newValue) {
                            setState(() {
                              _fromCurrency = newValue!;
                            });
                          },
                          label: 'From',
                        ),
                        IconButton(
                          icon: Icon(Icons.swap_horiz, color: Colors.deepPurple),
                          onPressed: () {
                            setState(() {
                              final temp = _fromCurrency;
                              _fromCurrency = _toCurrency;
                              _toCurrency = temp;
                            });
                          },
                        ),
                        _buildCurrencyDropdown(
                          value: _toCurrency,
                          onChanged: (newValue) {
                            setState(() {
                              _toCurrency = newValue!;
                            });
                          },
                          label: 'To',
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _convertCurrency,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 46, 43, 43),
                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Convert',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      _convertedAmount > 0
                          ? '$_amount $_fromCurrency = ${_convertedAmount.toStringAsFixed(2)} $_toCurrency'
                          : 'Conversion Result',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrencyDropdown({
    required String value,
    required void Function(String?)? onChanged,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle()),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.deepPurple, width: 1),
          ),
          child: DropdownButton<String>(
            value: value,
            underline: SizedBox(),
            items: currencies.map((String currency) {
              return DropdownMenuItem<String>(
                value: currency,
                child: Text(
                  currency,
                  style: TextStyle(),
                ),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
