import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _expression = '';
  String _result = '';

  void _onButtonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _expression = '';
        _result = '';
      } else if (buttonText == '=') {
        try {
          _result = _calculate(_expression);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        if (_result.isNotEmpty && !_isOperator(buttonText)) {
          _expression = '';
          _result = '';
        }
        _expression += buttonText;
      }
    });
  }

  bool _isOperator(String buttonText) {
    return buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '×' ||
        buttonText == '÷' ||
        buttonText == '%' ||
        buttonText == '(' ||
        buttonText == ')';
  }

  String _calculate(String expression) {
    try {
      String modifiedExpression = _handleModulus(expression);
      modifiedExpression =
          modifiedExpression.replaceAll('×', '*').replaceAll('÷', '/');
      final parser = Parser();
      final expressionAst = parser.parse(modifiedExpression);
      final result =
      expressionAst.evaluate(EvaluationType.REAL, ContextModel());
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  String _handleModulus(String expression) {
    RegExp regex = RegExp(r'(\d+\.?\d*)\s*%\s*(\d+\.?\d*)');
    while (regex.hasMatch(expression)) {
      expression = expression.replaceFirstMapped(regex, (match) {
        double leftOperand = double.parse(match.group(1)!);
        double rightOperand = double.parse(match.group(2)!);
        double result = leftOperand % rightOperand;
        return result.toString();
      });
    }
    return expression;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF64B2F6),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Color(0xFF0D294D),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _expression,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _result,
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildButtonRow(['(', ')', 'C', '÷']),
                  buildButtonRow(['7', '8', '9', '×']),
                  buildButtonRow(['4', '5', '6', '-']),
                  buildButtonRow(['1', '2', '3', '+']),
                  buildButtonRow(['0', '.', '=', '%']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(List<String> buttonTexts) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttonTexts
            .map((text) => Flexible(child: CalculatorButton(text, _onButtonPressed)))
            .toList(),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final String _text;
  final Function _onPressed;

  CalculatorButton(this._text, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65, // Increased height for better visibility
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)], // Gradient colors
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ElevatedButton(
          child: Text(
            _text,
            style: TextStyle(fontSize: 28, color: Colors.white), // Increased font size
          ),
          onPressed: () => _onPressed(_text),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15), // Padding for buttons
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
