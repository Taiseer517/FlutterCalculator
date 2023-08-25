import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData.dark(),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _previousExpression = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'AC') {
        _expression = '';
        _previousExpression = '';
      } else if (buttonText == '=') {
        try {
          _previousExpression = _expression;
          _expression = evaluateExpression(_expression);
        } catch (e) {
          _expression = 'Error';
        }
      } else if (buttonText == '<-') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (buttonText == '^') {
        _expression += '^';
      } else {
        if (_expression == 'Error') {
          _expression = '';
        }
        _expression += buttonText;
      }
    });
  }

  String evaluateExpression(String expression) {
    expression = expression.replaceAll('÷', '/');
    expression = expression.replaceAll('×', '*');
    expression = expression.replaceAll('%', '/100');

    Parser p = Parser();
    Expression exp = p.parse(expression);

    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    return eval.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Calculator'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.centerRight,
            child: Text(
              _previousExpression,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 20.0,
              ),
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: TextStyle(fontSize: 40.0),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height * 0.5,
            child: GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.5,
              padding: EdgeInsets.zero,
              mainAxisSpacing: 0.0,
              children: [
                '(', ')', '<-', 'AC',
                '7', '8', '9', '÷',
                '4', '5', '6', '×',
                '1', '2', '3', '-',
                '0', '00', '.', '+',
                '^', '/', '%', '=',
              ].map((buttonText) {
                return buttonText == '=' || buttonText == '/'
                    ? _buildButton(
                  buttonText,
                  color: buttonText == '=' ? Colors.orange : null,
                )
                    : _buildButton(
                  buttonText,
                  color: buttonText == 'AC' || buttonText == '<-' ? Colors.red : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String buttonText,
      {Color? color, bool doubleSize = false}) {
    double paddingSize = doubleSize ? 80.0 : 20.0;

    return ElevatedButton(
      onPressed: () => _onButtonPressed(buttonText),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: doubleSize ? 28 : 24,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: color ?? Color(0xFF12252FFF),
        padding: EdgeInsets.all(paddingSize),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide.none,
        ),
      ),
    );
  }
}
