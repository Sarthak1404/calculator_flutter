import 'package:calculator/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1="";
  String operators="";
  String number2="";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
             //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  // ignore: prefer_const_constructors
                  child: Text(
                    "$number1$operators$number2".isEmpty?"0":"$number1$operators$number2",
                    style: const TextStyle(
                      fontSize: 48, fontWeight: FontWeight.bold
                      ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //buttons
            Wrap(
                children: Btn.buttonValues
                .map(
                  (value) => SizedBox(
                    width: value==Btn.n0?
                      screenSize.width/2
                      :screenSize.width/4,
                    height: screenSize.width/4,
                    child: buildButton(value),
                  ))
                .toList()
              ),
          ],
        ),
      ),
    );
  }
  
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(15),
          ),
        child: InkWell(
          onTap:() => onBtnTap(value),
          child: Center(
            child: Text(value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              ),)
            ),
        ),
      ),
    );
  }

  void onBtnTap(String value){
    if(value == Btn.del){
      delete();
      return;
  }
  if(value == Btn.clr){
      clear();
      return;
  }
  if(value == Btn.per){
      percentage();
      return;
  }
  if(value == Btn.calculate){
      calculate();
      return;
  }  
    appendValue(value);
  }

  void calculate(){
    if(number1.isEmpty) return;
    if(operators.isEmpty) return;
    if(number2.isEmpty) return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result = 0.0;
    switch (operators){
      case Btn.add:
      result = num1 + num2;
      break;
      case Btn.substract:
      result = num1 - num2;
      break;
      case Btn.multiply:
      result = num1 * num2;
      break;
      case Btn.divide:
      result = num1 / num2;
      break;
    }
    setState(() {
      number1 = "$result";
      if(number1.endsWith(".0")){
        number1=number1.substring(0,number1.length-2);
      }
      number2="";
      operators="";
    });
  }

  void percentage(){
    if(number1.isNotEmpty&&operators.isNotEmpty&&number2.isNotEmpty){
      calculate();
    }
    if(operators.isNotEmpty){
      return;
    }
    final number = double.parse(number1);
    setState(() {
      number1 = "${(number/100)}";
      operators = "";
      number2 = "";
    });
  }

  void clear(){
    setState(() {
      number1="";
      number2="";
      operators="";
    });
  }

  void delete(){
    if(number2.isNotEmpty){
      number2=number2.substring(0,number2.length-1);
    }else if(operators.isNotEmpty){
      operators="";
    }else if(number1.isNotEmpty){
      number1=number1.substring(0,number1.length-1);
    }
    setState(() {
      
    });
  }

  void appendValue(String value){
    if(value!=Btn.dot&&int.tryParse(value)==null){
      //if value is operators & not'.'
      if(operators.isNotEmpty&&number2.isNotEmpty){
        calculate();
      }
      operators += value;
    // check value 1
    }else if(number1.isEmpty||operators.isEmpty){
      if(value==Btn.dot&&number1.contains(Btn.dot)) {
        // check if value is "."
       return;
      }
      if(value==Btn.dot&&(number1.isEmpty||number1==Btn.n0))
      {
        value="0.";
      }
      number1 += value;
    // check value 2
    }else if(number2.isEmpty||operators.isNotEmpty){
      if(value==Btn.dot&&number2.contains(Btn.dot)) return;
        // check if value is "."
      if(value==Btn.dot&&number2.isEmpty){
        value="0.";
      }
      if(value==Btn.dot&&number2==Btn.n0){
        value=".";
      }
      number2 += value;
    }
    setState(() {
    });
  }

  Color getBtnColor(value){
    return [Btn.del,Btn.clr].contains(value)
        ?Colors.blueGrey
        :{
          Btn.per,
          Btn.multiply,
          Btn.add,
          Btn.substract,
          Btn.divide,
          Btn.calculate}.contains(value)
          ?Colors.orange
          :Colors.black26;
  }
}