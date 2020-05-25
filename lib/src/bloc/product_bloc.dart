import 'dart:io';

import 'package:rxdart/subjects.dart';
import 'package:validacion_formularios/src/models/product_model.dart';
import 'package:validacion_formularios/src/providers/product_provider.dart';

class ProductBloc {
  
  final _productController = BehaviorSubject<List<ProductModel>>();
  final _loadingController = BehaviorSubject<bool>();

  final _productProvider = ProductProvider();

  Stream<List<ProductModel>> get productsStream => _productController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadingProduct() async {

    final products = await _productProvider.getProducts();
    _productController.sink.add(products);

  }

  void addProduct(ProductModel productModel ) async {

    _loadingController.sink.add(true);
    await _productProvider.createProduct(productModel);
    _loadingController.sink.add(false);

  }

  Future<String> uploadPhoto(File photo ) async {

    _loadingController.sink.add(true);
    final photoUrl = await _productProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return photoUrl;

  }

  void updateProduct(ProductModel productModel ) async {

    _loadingController.sink.add(true);
    await _productProvider.updateProduct(productModel);
    _loadingController.sink.add(false);

  }

  void removeProduct(String productId ) async => await _productProvider.removeProduct(productId);

  dispose() {
    _productController?.close();
    _loadingController?.close();
  }



}