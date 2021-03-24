import 'package:flutter/material.dart';

import 'package:form_validation_bloc/bloc/login_bloc.dart';
import 'package:form_validation_bloc/bloc/productos_bloc.dart';
export 'package:form_validation_bloc/bloc/login_bloc.dart';
export 'package:form_validation_bloc/bloc/productos_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = new LoginBloc();
  final _productosBloc = new ProductosBloc();

  //Patron Singlenton
  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  //Manera corta de un constructor
  //Provider({Key key, Widget child}) : super(key: key, child: child);

  //Quiere decir que al actualizarce debe notificar a sus hijos, en el 99.9% de los caso se pone true
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    //Toma el contexto(widgets tree) y busca un widget exactamente con el tipo de provider
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    //Toma el contexto(widgets tree) y busca un widget exactamente con el tipo de provider
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()
        ._productosBloc;
  }
}
