import 'dart:convert';

import 'package:form_validation_bloc/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _firebaseKey = 'AIzaSyCtexhxrrzFerJC6x-ZqrtFvnkczqDbXPg';
  final _prefs = new PreferenciasUsuario();

  login(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
        body: json.encode(authData));

    Map<String, dynamic> decodeRespuesta = json.decode(resp.body);
    print(decodeRespuesta);
    if (decodeRespuesta.containsKey('idToken')) {
      _prefs.token = decodeRespuesta['idToken'];
      return {'ok': true, 'token': decodeRespuesta['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeRespuesta['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': null
    };

    final resp = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
        body: json.encode(authData));

    Map<String, dynamic> decodeRespuesta = json.decode(resp.body);
    print(decodeRespuesta);
    if (decodeRespuesta.containsKey('idToken')) {
      _prefs.token = decodeRespuesta['idToken'];
      return {'ok': true, 'token': decodeRespuesta['idToken']};
    } else {
      return {'ok': false, 'mensaje': decodeRespuesta['error']['message']};
    }
  }
}
