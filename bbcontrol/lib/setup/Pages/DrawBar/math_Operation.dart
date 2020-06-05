import 'dart:math';

import 'package:string_validator/string_validator.dart';

class MathOperation{

  int randomNumber(int min, int max) {
    Random rnd = new Random();
    int r = min + rnd.nextInt(max - min + 1);
    return r;
  }

  List<String> operation(){
    List<String> resOperation = new List<String>();
    String operador = "+";
    String num1 = "";
    String num2 = "";

    num1 = randomNumber(30,70).toString();
    num2 = randomNumber(30,70).toString();
    resOperation.add(num1);
    resOperation.add(num2);

    if(toInt(num1)<55){
      operador = "+";
    }else{
      operador = "-";
    }
    resOperation.add(operador);
    return resOperation;
  }

  List<int> calculateResult(List<String> resOperation){

    List<int> posOptions = new List<int>();
    int result;

    if(resOperation[2]=="-") {
      result = toInt(resOperation[0]) - toInt(resOperation[1]);
    }
    else{
      result = toInt(resOperation[0])+toInt(resOperation[1]);
    }
    print(result);
    posOptions.add(result-randomNumber(1, 6));
    posOptions.add(result+randomNumber(1, 5));
    posOptions.add(result);
    print(posOptions);
    return posOptions;
  }

}