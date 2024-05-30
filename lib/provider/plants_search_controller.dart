import 'package:dio/dio.dart';
import 'package:etr_mark/const.dart';
import 'package:flutter/material.dart';

class PlantSearchController extends ChangeNotifier {
  List<dynamic> plants = [];
  bool isLoading = false;
  int page = 1;
  int lastPage = 1;
  int total = 1;
  String lastSearch = "";
  Future<void> searchPlant(String search) async {
    if (search.isEmpty ||
        isLoading ||
        (page > 1 && (page + 1 > lastPage) && lastSearch == search)) {
      return;
    }
    if (lastSearch != search) {
      page = 1;
      plants.clear();
      isLoading = true;
      notifyListeners();
    } else {
      page += 1;
    }
    lastSearch = search;

    final dio = Dio();

    final response = await dio.get(
      'https://perenual.com/api/species-list',
      queryParameters: {
        'key': apiKey,
        'page': page,
        'q': search,
      },
    );
    if (response.statusCode == 200) {
      final data = response.data['data'] as List<dynamic>;
      lastPage = int.parse(response.data['last_page'].toString());
      total = int.parse(response.data['total'].toString());
      plants.addAll(data);
    }
    isLoading = false;
    notifyListeners();
  }
}
