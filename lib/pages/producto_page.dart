import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation_bloc/bloc/provider.dart';
import 'package:form_validation_bloc/models/producto_model.dart';
import 'package:form_validation_bloc/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  //Creando una llave
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductosBloc productosBloc;

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
    final ProductoModel productoData =
        ModalRoute.of(context).settings.arguments;
    if (productoData != null) {
      producto = productoData;
    }
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Product'),
      //Se ejecuta despues de validar el campo
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3)
          return 'Ingrese el nombre del producto';
        else
          return null;
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Price'),
      //Se ejecuta despues de validar el campo
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'Solo Numeros';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        activeColor: Colors.deepPurple,
        value: producto.disponible,
        title: Text('Disponible'),
        onChanged: (value) => setState(() => producto.disponible = value));
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text(
        'Guardar',
      ),
      icon: Icon(
        Icons.save,
        color: Colors.white,
      ),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit() async {
    //Es true si el formulario es valido
    if (!formKey.currentState.validate()) return;
    //Disparar los onSave para poder capturar los valores
    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });
    if (photo != null) {
      producto.fotoUrl = await productosBloc.subirFoto(photo);
    }
    /* 
    Aunque no este relacionado el switch con el Form, podemos obtener su valor, ya que
    el objeto producto esta siendo utilizado por widgets del formulatio (TextFormField) 
    */
    //print(producto.disponible);
    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
    } else {
      productosBloc.editarProducto(producto);
    }

    /*setState(() {
      _guardando = false;
    });*/
    _mostrarSnackbar(
        mensaje: 'Registro guardado', duracion: 1000, color: Colors.green);

    Navigator.pop(context);
  }

  void _mostrarSnackbar({String mensaje, int duracion, Color color}) {
    final snackbar = SnackBar(
        backgroundColor: color,
        content: Text(mensaje),
        duration: Duration(milliseconds: duracion));

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        //Mantener dimensiones y que se vea bien la imagen, es decir el contenedor se adapta al tamaño de la imagen
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    photo = await ImagePicker.pickImage(source: origen);

    if (photo != null) {
      producto.fotoUrl = null;
    }
    setState(() {});
  }
}
