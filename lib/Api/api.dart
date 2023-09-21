import 'dart:convert';
import 'dart:io';

import 'package:orgone_app/helper/const.dart';
import 'package:orgone_app/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum ApiType { POST, GET, PUT, DELETE, PATCH }

getPostCall(String url, Map<String, dynamic> body) async {
  var res = await http.post(Uri.parse(url), body: body, headers: {
    'Authorization': 'Bearer $constToken',
  });
  return res;
}

getGetCall(String url) async {
  var res = await http.get(Uri.parse(url), headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $constToken',
  });
  return res;
}
