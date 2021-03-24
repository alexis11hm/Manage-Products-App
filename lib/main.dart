import 'package:flutter/material.dart';
import 'package:form_validation_bloc/bloc/provider.dart';
import 'package:form_validation_bloc/pages/home_page.dart';
import 'package:form_validation_bloc/pages/login_page.dart';
import 'package:form_validation_bloc/pages/producto_page.dart';
import 'package:form_validation_bloc/pages/resgistro_page.dart';
import 'package:form_validation_bloc/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = PreferenciasUsuario();
    print(prefs.token);
    return Provider(
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext contex) => LoginPage(),
        'home': (BuildContext contex) => HomePage(),
        'producto': (BuildContext contex) => ProductoPage(),
        'registro': (BuildContext contex) => RegistroPage()
      },
      theme: ThemeData(primaryColor: Colors.deepPurple),
    ));
  }
}
