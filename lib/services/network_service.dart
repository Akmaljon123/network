import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

@immutable
sealed class NetworkService{


  static const String _baseUrl = "dummyjson.com";

  static const String apiGetAllProduct = "/products";
  static const String apiCategoryProducts = "/products/category/";
  static const String apiLogin = "/auth/login";
  static const String apiSearchProduct = "/products/search";

  static const Map<String, String> headers = {
    "Content-Type":"application/json"
  };

  static Map<String, Object?>paramEmpty() => const <String, Object?>{};

  static Map<String, Object?>paramSearchProduct(String text) => <String, Object?>{
    "q":text,
  };


  static Future<String?>getData({required String api, required Map<String, Object?>param})async{
    Uri url = Uri.https(_baseUrl, api, param);
    Response response = await get(url, headers: headers);
    if(response.statusCode <= 201){
      return response.body;
    }else{
      return null;
    }
  }


  static Future<String?>postData({required String api, required Map<String, Object?>param, required Map<String, Object?> data})async{
    Uri url = Uri.https(_baseUrl, api, param);
    Response response = await post(url, body: jsonEncode(data),headers: headers);
    if(response.statusCode <= 201){
      return response.body;
    }else{
      return null;
    }
  }


  static Future<String?>updateData({required String api, required Map<String, Object?>param, required Map<String, Object?> data})async{
    Uri url = Uri.https(_baseUrl, api, param);
    Response response = await put(url, body: jsonEncode(data),headers: headers);
    if(response.statusCode <= 201){
      return response.body;
    }else{
      return null;
    }
  }

  static Future<String?>deleteData({required String api, required Map<String, Object?>param, required Map<String, Object?> data})async{
    Uri url = Uri.https(_baseUrl, api, param);
    Response response = await delete(url, body: jsonEncode(data),headers: headers);
    if(response.statusCode <= 201){
      return response.body;
    }else{
      return null;
    }
  }
}