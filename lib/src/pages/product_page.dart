import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/models/product_model.dart';
import 'package:validacion_formularios/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formkey = GlobalKey<FormState>();

  ProductModel product = ProductModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.photo_size_select_actual), onPressed: (){}),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: (){})
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                _nameField(),
                _priceField(),
                _availableField(),
                SizedBox(height: 20.0),
                _sumbitButton()
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _nameField() {

    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => product.title = value, 
      validator: (value){
        return ( value.length < 3 ) ?
          'Ingrese el nombre del producto' : 
          null;
      },
    );

  }

  Widget _priceField() {

    return TextFormField(
      initialValue: product.price.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
      labelText: 'Precio'
      ),
      onSaved: (value) => product.price = double.parse(value), 
      validator: (value){
        return (utils.isNumeric(value)) ? null : 'Solo números';
      },
    );

  }

  Widget _availableField() {

    return CheckboxListTile(
      value: product.available,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){ product.available = value;})
    );

  }

  Widget _sumbitButton() {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: _submit,
    );

  }

  void _submit() {

    if (!formkey.currentState.validate()) return;

    formkey.currentState.save();

    print('Title: ${product.title}');
    print('Price: ${product.price}');
    print('Available: ${product.available}');

  }
}