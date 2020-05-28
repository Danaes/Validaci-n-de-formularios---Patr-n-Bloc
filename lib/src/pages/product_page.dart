import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';
import 'package:validacion_formularios/src/models/product_model.dart';
import 'package:validacion_formularios/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formkey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductBloc productBloc;
  ProductModel product = ProductModel();
  bool _isToUpdate;
  bool _saving = false;
  File photo;

  @override
  Widget build(BuildContext context) {

    productBloc = Provider.productBloc(context);

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;
    _isToUpdate = prodData != null;
    if ( _isToUpdate )  product = prodData;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.photo_size_select_actual), onPressed: _selectPhoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _takePhoto)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                _photoField(),
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

    String label = _isToUpdate ? 'Actualizar' : 'Crear';

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text(label),
      icon: Icon(Icons.save),
      onPressed: (_saving) ? null : _submit ,
    );

  }

  void _submit() async {

    if (!formkey.currentState.validate()) return;

    formkey.currentState.save();

    setState(() { _saving = true; });

    if (photo != null) {
      product.photoUrl = await productBloc.uploadPhoto(photo);
    }

    if (product.id == null)
      productBloc.addProduct(product);
    else
      productBloc.updateProduct(product);

    showSnackBar('Producto guardado correctamente');
    Navigator.of(context).pushNamedAndRemoveUntil('home', (Route<dynamic> route) => false);

  }

  void showSnackBar(String msg){

    final snackbar = SnackBar(
      content: Text(msg),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _photoField() {

    if( product.photoUrl != null)
      return FadeInImage(
        placeholder: AssetImage('assets/original.gif'), 
        image: NetworkImage(product.photoUrl),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.fill,
      );

    return Image(
      image: AssetImage(photo?.path ?? 'assets/no-image.png'),
      height: 300.0,
      fit: BoxFit.cover
    );
  }

  _selectPhoto () => _processPhoto(ImageSource.gallery);

  _takePhoto ()  => _processPhoto(ImageSource.camera);

  _processPhoto(ImageSource imageSource) async {

    photo = await ImagePicker.pickImage(
      source: imageSource
    );

    if(photo != null) {
        product.photoUrl = null;
    }

    setState(() {});
  }
}