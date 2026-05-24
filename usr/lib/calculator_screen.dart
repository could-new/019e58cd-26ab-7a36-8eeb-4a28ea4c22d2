import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _operand1 = '';
  String _operand2 = '';
  String _operator = '';
  bool _isNewNumber = true;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _display = '0';
        _operand1 = '';
        _operand2 = '';
        _operator = '';
        _isNewNumber = true;
      } else if (buttonText == '+/-') {
        if (_display != '0' && _display.isNotEmpty) {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
          } else {
            _display = '-$_display';
          }
        }
      } else if (buttonText == '%') {
        try {
          double val = double.parse(_display);
          _display = (val / 100).toString();
          if (_display.endsWith('.0')) {
            _display = _display.substring(0, _display.length - 2);
          }
        } catch (_) {}
      } else if (buttonText == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
          _isNewNumber = true;
        }
      } else if (buttonText == '+' ||
          buttonText == '-' ||
          buttonText == '×' ||
          buttonText == '÷') {
        _operand1 = _display;
        _operator = buttonText;
        _isNewNumber = true;
      } else if (buttonText == '=') {
        if (_operator.isNotEmpty && _operand1.isNotEmpty) {
          _operand2 = _display;
          try {
            double num1 = double.parse(_operand1);
            double num2 = double.parse(_operand2);
            double result = 0;

            switch (_operator) {
              case '+':
                result = num1 + num2;
                break;
              case '-':
                result = num1 - num2;
                break;
              case '×':
                result = num1 * num2;
                break;
              case '÷':
                result = num2 != 0 ? num1 / num2 : double.nan;
                break;
            }

            _display = result.toString();
            if (_display.endsWith('.0')) {
              _display = _display.substring(0, _display.length - 2);
            }
          } catch (_) {
            _display = 'Error';
          }
          _operand1 = _display;
          _operator = '';
          _isNewNumber = true;
        }
      } else {
        if (_isNewNumber) {
          _display = buttonText;
          _isNewNumber = false;
        } else {
          if (buttonText == '.' && _display.contains('.')) return;
          _display = _display == '0' && buttonText != '.'
              ? buttonText
              : _display + buttonText;
        }
      }
    });
  }

  Widget _buildButton(String text, {Color? color, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey[800],
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () => _buttonPressed(text),
        child: Text(
          text,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxContentWidth = constraints.maxWidth > 500 ? 500 : constraints.maxWidth;
            
            return Center(
              child: SizedBox(
                width: maxContentWidth,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        child: Text(
                          _display,
                          style: const TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: GridView.count(
                        crossAxisCount: 4,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildButton('C',
                              color: Colors.grey[400], textColor: Colors.black),
                          _buildButton('+/-',
                              color: Colors.grey[400], textColor: Colors.black),
                          _buildButton('%',
                              color: Colors.grey[400], textColor: Colors.black),
                          _buildButton('÷', color: Colors.orange),
                          _buildButton('7'),
                          _buildButton('8'),
                          _buildButton('9'),
                          _buildButton('×', color: Colors.orange),
                          _buildButton('4'),
                          _buildButton('5'),
                          _buildButton('6'),
                          _buildButton('-', color: Colors.orange),
                          _buildButton('1'),
                          _buildButton('2'),
                          _buildButton('3'),
                          _buildButton('+', color: Colors.orange),
                          _buildButton('.'),
                          _buildButton('0'),
                          _buildButton('⌫'),
                          _buildButton('=', color: Colors.orange),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
