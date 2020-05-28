import 'package:flutter/material.dart';

import 'src/bloc/provider.dart';
import 'src/pages/singup_page.dart';
import 'src/pages/home_page.dart';
import 'src/pages/login_page.dart';
import 'src/pages/product_page.dart';
import 'src/preferences/user_preference.dart';
 
void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreference();
  await prefs.initPrefs();

  runApp(MyApp());

}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new UserPreference();


    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: prefs.ultimaPagina,
        routes: {
          'login'    : (BuildContext context) => LoginPage(),
          'singup'    : (BuildContext context) => SingupPage(),
          'home'     : (BuildContext context) => HomePage(),
          'product'  : (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
  }
}