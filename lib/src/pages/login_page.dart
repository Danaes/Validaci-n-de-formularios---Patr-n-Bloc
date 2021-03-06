import 'package:flutter/material.dart';
import 'package:validacion_formularios/src/bloc/login_bloc.dart';
import 'package:validacion_formularios/src/bloc/provider.dart';
import 'package:validacion_formularios/src/preferences/user_preference.dart';
import 'package:validacion_formularios/src/providers/user_provider.dart';
import 'package:validacion_formularios/src/utils/utils.dart' as utils;

class LoginPage extends StatefulWidget {

  static final String routeName = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userProvider = UserProvider();
  
  final prefs = new UserPreference();

  bool _saving = false;

  @override
  Widget build(BuildContext context) {

    prefs.ultimaPagina = LoginPage.routeName;

    return Scaffold(
      body:  Stack(
        children: <Widget>[
          _creadFondo(context),
          _loginForm(context),
        ],
      )
    );
  }

  Widget _creadFondo(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    
    final fondoMorado = Container(
      height: size.height * 0.5,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: <Color> [
          Color.fromRGBO(67, 67, 156, 1.0),
          Color.fromRGBO(90, 70, 178, 1.0)
        ])
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40, right: -30.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 60.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              SizedBox(height: 10.0, width: double.infinity,),
            ],
          ),
        )
      ],
    );
  }

  Widget _loginForm(BuildContext context) {
    
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

          SafeArea(child: Container(height: size.height * 0.25,)),

          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            margin: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black26, blurRadius: 3.0, offset: Offset(0.0, 5.0), spreadRadius: 3.0)
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Iniciar sesión', style: TextStyle(fontSize: 20.0),),
                SizedBox(height: 60.0),
                _crearEmail(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(bloc)
              ],
            ),
          ),
        
          FlatButton(
            child: Text('Crear una nueva cuenta', style: TextStyle(color: Colors.deepPurple)),
            onPressed: () => Navigator.pushReplacementNamed(context, 'singup'),
          ),
          SizedBox(height: 100.0),
        ],
      ),
    );

  }

  Widget _crearEmail(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple,),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              errorText: snapshot.error
            ),
          onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {

    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple,),
              labelText: 'Contraseña',
              errorText: snapshot.error
            ),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );

  }

  Widget _crearBoton(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Iniciar sesion'),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0)
          ),
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: (snapshot.hasData && !_saving) ? () => _login(bloc, context) : null,
        );
      });
  }

  void _login(LoginBloc bloc, BuildContext context) async {

    setState(() { _saving = true; });

    Map info = await _userProvider.login(bloc.email, bloc.password);

    if(info['ok']) Navigator.pushReplacementNamed(context, 'home');
    else {
      setState(() { _saving = false; });
      utils.showAlert(context, info['msg']);
    }
  }
}