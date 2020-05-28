import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:validacion_formularios/src/models/product_model.dart';
import 'package:validacion_formularios/src/preferences/user_preference.dart';

class ProductProvider {

  final String _url = 'https://flutter-products-5c063.firebaseio.com';
  final _prefs = UserPreference();

  Future<bool> createProduct(ProductModel product) async {

    final url = '$_url/products.json?auth=${_prefs.token}';

    await http.post(url, body: productModelToJson(product));


    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {

    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    await http.put(url, body: productModelToJson(product));


    return true;
  }


  Future<List<ProductModel>> getProducts() async {

    final url = '$_url/products.json?auth=${_prefs.token}';
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductModel> products = List();

    if (decodedData == null) return [];

    decodedData.forEach((id, product) {

      final prodTemp = ProductModel.fromJson(product);
      prodTemp.id = id;

      products.add(prodTemp);

    });

    return products;

  }

  Future<int> removeProduct(String id) async {
    final url = '$_url/products/$id.json?auth=${_prefs.token}';
    await http.delete(url);

    return 1;
  }

  Future<String> uploadImage(File image) async {

    final uri = Uri.parse('https://api.cloudinary.com/v1_1/dfdipihkr/image/upload?upload_preset=t3dkaqae');
    final mimeType = mime(image.path).split('/');

    final uploadRequest = http.MultipartRequest('POST',uri);

    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    uploadRequest.files.add(file);

    final streamReponse = await uploadRequest.send();
    final resp = await http.Response.fromStream(streamReponse);

    if( resp.statusCode != 200 && resp.statusCode != 201) return null; //algo salió mal

    final respData = json.decode(resp.body);

    return respData['secure_url'];

  }
  
}