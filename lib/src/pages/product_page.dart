import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formkey = GlobalKey<FormState>();

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
                _name(),
                _price(),
                SizedBox(height: 20.0),
                _sumbitButton()
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _name() {

    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      validator: (value){
        return ( value.length < 3 ) ?
          'Ingrese el nombre del producto' : 
          null;
      },
    );

  }

  Widget _price() {

    return TextFormField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
      labelText: 'Precio'
      ),
      validator: (value){
        return (utils.isNumeric(value)) ? null : 'Solo números';
      },
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

    

  }
}