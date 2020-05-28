import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/product_bloc.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';
import 'package:validacion_formularios/src/models/product_model.dart';


class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    Provider.of(context);
    final productBloc = Provider.productBloc(context);
    productBloc.getProduct();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: _listProduct(productBloc),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add), 
        onPressed: () => Navigator.pushNamed(context, 'product')
      ),
    );
  }

  Widget _listProduct(ProductBloc productBloc) {

    return StreamBuilder(
      stream: productBloc.productsStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {

        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        final products = snapshot.data;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, i) => _itemProduct(context, products[i], productBloc),
        );
      }
    );

  }

  Widget _itemProduct(BuildContext context, ProductModel product, ProductBloc productBloc) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.redAccent
      ),
      onDismissed: (direction) => productBloc.removeProduct(product.id),
      child: ListTile(
        title: Text(product.title),
        subtitle: Text(product.price.toString()),
        onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
        leading: Container(
          width: 75.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: (product.photoUrl == null) ?
              Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.fill,
              ) :
              FadeInImage(
                image: NetworkImage(product.photoUrl),
                placeholder: AssetImage('assets/original.gif'),
                fit: BoxFit.fill,
              ),
          )
        )
      ),
    );

  }
}