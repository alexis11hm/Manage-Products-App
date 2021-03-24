import 'dart:convert';
import 'dart:io';
import 'package:form_validation_bloc/preferencias_usuario/preferencias_usuario.dart';
import 'package:mime_type/mime_type.dart' as mime;
import 'package:http_parser/http_parser.dart';

import 'package:form_validation_bloc/models/producto_model.dart';

import 'package:http/http.dart' as http;

class ProductosProvider {
  final String _url = 'https://flutter-varios-4c4da.firebaseio.com';
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.post(url, body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData == null) return [];
    if (decodedData['error'] != null) return [];
    final List<ProductoModel> productos = new List();
    decodedData.forEach((id, producto) {
      /*print(id);
      print(producto);*/
      final productoTemporal = ProductoModel.fromJson(producto);
      productoTemporal.id = id;
      productos.add(productoTemporal);
    });
    return productos;
  }

  Future<int> borrarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final resp = await http.delete(url);
    final decodedData = json.decode(resp.body);
    return 1;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';
    final resp = await http.put(url, body: productoModelToJson(producto));
    final decodedData = json.decode(resp.body);
    print(decodedData);
    return true;
  }

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dqqcuvan6/image/upload?upload_preset=g2kcbhpo');
    final mineType = mime.mime(imagen.path).split('/'); // imagen/jpg
    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mineType[0], mineType[1]));

    imageUploadRequest.files.add(file);
    //Se pueden subir mas imagenes a la vez
    //imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);
    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }
    final respuestaData = json.decode(resp.body);
    print(respuestaData);
    return respuestaData['secure_url'];
  }
}
