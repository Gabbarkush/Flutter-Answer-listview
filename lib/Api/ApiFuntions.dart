import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:practice/Common/Constant.dart';
import 'package:http/http.dart' as http;

import '../Common/Common.dart';

class ApiFuntions{

  Future<http.Response> getdata(BuildContext context, String endpoint) async {
    print(context);
    Common.showLoaderDialog(context);
    final response = await http.get(
        Uri.parse(
            '${Constant.baseurl}${endpoint}'),
        /*headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        });*/);
    print("${Constant.baseurl}${endpoint}");
    print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.pop(context);
      print(response);
      return response;
    } else {
      Navigator.pop(context);
      Map<String, dynamic> message = (jsonDecode(response.body));
      var mes = message['status_message'];
      print(response.body);
      print(mes);
      return mes;
      //Common.showToast(mes);
    }
  }
}