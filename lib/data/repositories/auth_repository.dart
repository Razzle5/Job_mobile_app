import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//http api

class AuthRepository {
  static const String _baseUrl = 'http://localhost:8000';
}

Future<Map<String,dynamic>> registerHrd(String email, String password)async{
  final url = Uri.parse('$_baseUrl/hrd/register');

  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-type' : 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email':email,
      'password' : password,
    }),
);

final responseBody = jsonDecode(response.body);

if (response.statusCode == 201){
  return {'success': true, 'data': responseBody};
} else{
  return {'success': false, 'message': responseBody['message']?? 'Unknown','errors': responseBody['errors']};
  }
}
