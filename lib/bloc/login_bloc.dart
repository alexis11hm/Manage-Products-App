import 'dart:async';

import 'package:form_validation_bloc/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  //Son como los StreamController
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar los datos del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  //Recibe el valor de 2 streams o behaviorsubject, cuando los dos no tenga info nula, entonces retorna un true
  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener el ultimo valor ingresado en los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  //Es necesario cerrarlos, porque sino genera error
  dispose() {
    // ? Si es nulo, evita que se llave el metodo close()
    _emailController?.close();
    _passwordController?.close();
  }
}
