import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:person_list/model/post_model.dart';

abstract class IPostService {
  Future<List<PostModel>?> fetchPostItemsAdvance();
}

class PostService implements IPostService {
  late final Dio _dio;
  PostService() : _dio = Dio(BaseOptions(baseUrl: 'https://reqres.in/api/'));

  @override
  Future<List<PostModel>?> fetchPostItemsAdvance() async {
    try {
      final response = await _dio.get('users?page=2');

      if (response.statusCode == HttpStatus.ok) {
        final datas = response.data['data'];
        if (datas is List) {
          return datas.map<PostModel>((e) => PostModel.fromJson(e)).toList();
        }
      }
    } on DioException catch (error) {
      _ShowDebugError()._showDioException(error, this);
    }
    return null;
  }
}

class _ShowDebugError {
  void _showDioException<T>(DioException error, T type) {
    if (kDebugMode) {
      print(error.message);
      print(type);
      print('---------------------');
    }
  }
}
