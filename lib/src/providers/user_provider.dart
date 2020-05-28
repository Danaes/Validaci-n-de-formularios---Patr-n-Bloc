import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:validacion_formularios/src/preferences/user_preference.dart';

class UserProvider {

  final _prefs = UserPreference();
  final String _firebaseToken = 'AIzaSyDKUcC36QPVpJZtsPRuW4CcW3DYQbMkNuE';

  Future<Map<String, dynamic>> login (String email, String password) async {

    final String url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken';
    return _sessionUser(email, password, url);
  }


  Future<Map<String, dynamic>> singup(String email, String password) async {

    final String url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken';
    return _sessionUser(email, password, url);
  }

  Future<Map<String, dynamic>> _sessionUser(String email, String password, String url) async {

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      url,
      body: json.encode(authData)
    );
    
    Map<String, dynamic> decodeResp = json.decode(resp.body);

    Map<String, dynamic> map;

    if (decodeResp.containsKey('idToken')){
      _prefs.token =  decodeResp['idToken'];
      map = {'ok': true, 'token': decodeResp['idToken']};
    } else
      map = {'ok': false, 'msg': decodeResp['error']['message']};


    return map;

  }

}