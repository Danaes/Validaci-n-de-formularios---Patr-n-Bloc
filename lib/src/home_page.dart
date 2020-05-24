import 'package:flutter/material.dart';

// import 'bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add), 
        onPressed: () => Navigator.pushNamed(context, 'product')
      ),
    );
  }
}