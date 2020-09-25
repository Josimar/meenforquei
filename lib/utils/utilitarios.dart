import 'package:flutter/material.dart';

enum TamanhoCaixa{
  Peq,
  Med,
  Gnd
}

enum FilterOptions{
  Favorite,
  All
}

class Utilitarios{
  Utilitarios();

  void debugPrint(dynamic value) {
    print(value);
  }
}

class RouteArguments {
  dynamic systemModel;
  dynamic userModel;

  RouteArguments(this.systemModel, this.userModel);
}

class CounterState{
  int _value = 1;

  void inc() => _value++;
  void dec() => _value--;
  int get value => _value;

  bool diff(CounterState old){
    return old == null || old._value != _value;
  }
}

class CounterProvider extends InheritedWidget{

  final CounterState state = CounterState();

  CounterProvider({Widget child}) : super(child: child);

  static CounterProvider of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<CounterProvider>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}