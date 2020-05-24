import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/models/product_model.dart';
import 'package:validacion_formularios/src/providers/product_provider.dart';

// import 'bloc/provider.dart';

class HomePage extends StatelessWidget {

  final productProvider =  ProductProvider();

  @override
  Widget build(BuildContext context) {

    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: _listProduct(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add), 
        onPressed: () => Navigator.pushNamed(context, 'product')
      ),
    );
  }

  Widget _listProduct() {

    return FutureBuilder(
      future: productProvider.getProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final products = snapshot.data;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, i) => _itemProduct(context, products[i]),
        );
      }
    );

  }

  Widget _itemProduct(BuildContext context, ProductModel product) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red
      ),
      onDismissed: (direction) {
        productProvider.removeProduct(product.id);
      },
      child: ListTile(
        title: Text(product.title),
        subtitle: Text(product.price.toString()),
        onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
      ),
    );

  }
}