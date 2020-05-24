import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:validacion_formularios/src/models/product_model.dart';

class ProductProvider {

  final String _url = 'https://flutter-products-5c063.firebaseio.com';

  Future<bool> createProduct(ProductModel product) async {

    final url = '$_url/products.json';

    await http.post(url, body: productModelToJson(product));


    return true;
  }

  Future<bool> updateProduct(ProductModel product) async {

    final url = '$_url/products/${product.id}.json';

    await http.put(url, body: productModelToJson(product));


    return true;
  }


  Future<List<ProductModel>>  getProducts() async {

    final url = '$_url/products.json';
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
    final url = '$_url/products/$id.json';
    await http.delete(url);

    return 1;
  }
  
}