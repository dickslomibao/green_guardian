import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:etr_mark/const.dart';
import 'package:flutter/material.dart';

class PlantsController extends ChangeNotifier {
  List<dynamic> plants = [];
  bool isLoading = false;
  int page = 0;
  int total = 10102;
  bool isError = false;
  String errorMessage = "Something went wrong. Try to refresh";
  Future<void> fetchPlant() async {
    if (isLoading) {
      return;
    }
    if (isError) {
      isLoading = true;
      notifyListeners();
    }
    if (!isError) {
      page += 1;
    } else {
      isError = false;
    }
    final dio = Dio();
    try {
      final response = await dio.get(
        'https://perenual.com/api/species-list',
        queryParameters: {
          'key': apiKey,
          'page': page,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        plants.addAll(data);
      }
    } on DioException catch (e) {
      isError = true;
      if (e.response != null &&
          (e.response!.statusCode == 404 ||
              e.response!.data.containsKey('X-RateLimit-Limit'))) {
        errorMessage = "Please check your api key and refresh it.";
      }
    } catch (e) {
      isError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
